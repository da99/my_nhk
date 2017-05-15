
# === {{BIN}}  --json
# === {{BIN}}  titles          # Prints: NUM TITLE : SUBTITLE
# === {{BIN}}  choose  desc|record-info|record
# === {{BIN}}  desc        ID
# === {{BIN}}  record-info ID # Prints: START SECONDS  UNIQ_ID
# === {{BIN}}  current
# === {{BIN}}  next    [Search String]
# === {{BIN}}  next-id Search String
my_nhk () {
  cd "$THIS_DIR"
  case "$@" in
    "--json")
      "$THIS_DIR"/private/nhk.py "$@"
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
      local +x FOUND="$(my_nhk titles | tail -n+2 | grep -i -P "$TARGET" | head -n1 | cut -d':' -f1 || :)"
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
      my_nhk --json > tmp/nhk.json
      "$THIS_DIR"/private/nhk.py tmp/ "$@" | {
        while read -r LINE ; do
          sh_color BOLD "$LINE"
        done
      }
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
