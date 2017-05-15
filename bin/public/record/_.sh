
# === {{CMD}}  ID
# === {{CMD}}  --silent ID
record () {
  local +x IS_SILENT=""
  if [[ "$@" == *"silent"* ]]; then
    local +x IS_SILENT="--silent"
    shift
  fi

  local +x NUM="$1"; shift
  if my_nhk is-skip "$NUM" ; then
    echo "=== Skipping: $(my_nhk title $NUM 2>/dev/null || :) (ID: $NUM)" >&2
    exit 0
  fi

  local +x INFO="$(my_nhk record-info $NUM || :)"
  if [[ -z "$INFO" ]]; then
    exit 2
  fi

  set $INFO
  local +x STARTS="$1"
  local +x SECS="$2"
  local +x SHOW_TITLE="$3"
  local +x FILE="/tmp/nhk.$3.raw"
  local +x FILE_TMP="${FILE}.tmp"
  local +x A_ID="$4"
  local +x NOW="$(date +"%s")"
  local +x WAIT_TIME="$(($STARTS - $NOW))"
  local +x MINS="$(( WAIT_TIME / 60))"

  if [[ -e "$FILE" ]]; then
    echo "=== Already exists: $FILE" >&2
    exit 4
  fi

  echo "=== Waiting to record: $SHOW_TITLE" >&2
  sleep "$WAIT_TIME"

  rm -f "$FILE_TMP"
  curl $IS_SILENT -o "$FILE_TMP" http://bdrm:2110 --max-time "$SECS" || {
    local +x STAT="$?"
    if [[ "$STAT" -eq "28" ]]; then
      exit 0
    fi
    exit "$STAT"
  }
  mv -f "$FILE_TMP" "$FILE"
  my_nhk skip "$A_ID"
} # === end function
