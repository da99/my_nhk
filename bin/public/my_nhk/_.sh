
# === {{BIN}}  schedule
# === {{BIN}}  titles          # Prints: NUM TITLE : SUBTITLE
# === {{BIN}}  choose  desc|record-info|record
# === {{BIN}}  desc        ID
# === {{BIN}}  record-info ID # Prints: START SECONDS  UNIQ_ID
# === {{BIN}}  current
# === {{BIN}}  next    [Search String]
# === {{BIN}}  next-id Search String

local +x PATH="$PATH:$THIS_DIR/../my_fs/bin"
schedule-from-cache () {
  ls -1 tmp/schedules | sort | tail -n1 | {
    read -r LINE
    realpath "$THIS_DIR/tmp/schedules/$LINE"
  }
}


schedule-download () {
  local +x NOW="$(date +"%Y-%m-%d-%H-%M-%S")"
  local +x NEW_FILE="tmp/schedules/${NOW}.json"
  local +x TMP_FILE="tmp/schedule.${NOW}.json.tmp"
  "$THIS_DIR"/private/nhk.py "schedule-download" > "$TMP_FILE" || {
    rm -f "$TMP_FILE"
  }
  if [[ -f "$TMP_FILE" ]]; then
    mv "$TMP_FILE" "$NEW_FILE"
  fi
}

my_nhk () {
  unset -f my_nhk
  cd "$THIS_DIR"

  local +x SCHEDULE="$(schedule-from-cache)"

  case "$@" in

    "schedule")
      if [[ ! -z "$SCHEDULE" ]] && my_fs is-younger-than $(( 60 * 10 )) "$SCHEDULE" ; then
        local +x FILE="$SCHEDULE"
      else
        my_nhk cache --clear
        schedule-download
        local +x FILE="$(schedule-from-cache)"
      fi

      if [[ -z "$FILE" ]]; then
        echo "!!! Could not retrieve schedule after repeated attempts" >&2
        exit 5
      fi

      echo "$FILE"
      ;;

    choose|choose" "*)
      unset -f my_nhk
      shift
      my_nhk titles | fzy | head -n 1 | cut -d':' -f1 | {
        read -r ID
        my_nhk desc "$ID"
        case "$@" in
          record)
            verbose-record "$ID"
            my_nhk record "$ID"
            ;;

          "")
            return 0
            ;;
          *)
            my_nhk "$@" "$ID"
            ;;
        esac
      }
      ;;

    "next-id "*)
      unset -f my_nhk
      shift
      local +x TARGET="$@"
      local +x FOUND="$(my_nhk nexts | grep -i -P "$TARGET" | head -n1 | cut -d':' -f1 || :)"
      if [[ -z "$FOUND" ]]; then
        exit 1
      fi
      echo "$FOUND"
      ;;

    "next "*)
      unset -f my_nhk
      shift
      my_nhk next-id "$@" | {
        read -r ID
        my_nhk desc $ID
      }
      ;;

    *)
      mkdir -p tmp
      my_nhk schedule > tmp/nhk.json
      "$THIS_DIR"/private/nhk.py "$@" "$(my_nhk schedule)"
      ;;
  esac
} # === end function

verbose-record () {
  local +x NUM="$1"; shift
  local +x INFO="$(my_nhk record-info $NUM)"
  if [[ -z "$INFO" ]]; then
    exit 2
  fi

  set $INFO
  local +x STARTS="$1"
  local +x SECS="$2"
  local +x FILE="/tmp/nhk.$3.raw"
  local +x A_ID="$4"
  local +x NOW="$(date +"%s")"
  local +x WAIT_TIME="$(($STARTS - $NOW))"
  local +x MINS="$(( WAIT_TIME / 60))"

  echo "$FILE"
  local +x COUNTER="0"
  while [[ "$COUNTER" -lt "$WAIT_TIME" ]]; do
    COUNTER="$(( COUNTER + 1 ))"
    local +x COUNTER_MINS=$(( (WAIT_TIME - COUNTER)/60 ))
    echo -en "\r=== Starts in: $(( (WAIT_TIME - COUNTER)/60 )) mins. "
    echo -n "$(( (WAIT_TIME - COUNTER - (COUNTER_MINS * 60)) )) secs. "
    sleep 1
  done
  echo -e "\r                                 "
} # === choose-record
