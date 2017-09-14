
# === {{CMD}}  ID
# === {{CMD}}  --silent ID
# === Waits until show starts, checks skip record, then starts recording.
record () {
  my_nhk cache --clear || :
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

  # === For some reason video cuts off if time is <20 mins,
  # === so compensate by adding an extra 120 seconds:
  if [[ "$SECS" -lt "$(( (60 * 20) + 10 ))" ]]; then
    SECS="$(( SECS + 120 ))"
  else
    SECS="$(( SECS + 60 ))"
  fi

  local +x SHOW_TITLE="$3"
  local +x FILE="/play/nhk/nhk.$3.mp4"
  local +x FILE_TMP="${FILE}.tmp"
  local +x A_ID="$4"
  local +x NOW="$(date +"%s")"
  local +x WAIT_TIME="$(($STARTS - $NOW))"
  local +x MINS="$(( WAIT_TIME / 60))"

  if [[ -e "$FILE" ]]; then
    echo "=== Already exists: $FILE" >&2
    exit 4
  fi

  if [[ "$WAIT_TIME" -lt 1 ]]; then
    echo "!!! Show is not in the future: $(date): $SHOW_TITLE" >&2
    exit 2
  fi
  echo "=== $(date +"%I:%M:%S %p"): Waiting to record: $SHOW_TITLE ($SECS seconds)" >&2
  sleep "$WAIT_TIME"

  if my_nhk is-skip "$NUM" ; then
    echo "=== Skipping: $(my_nhk title $NUM 2>/dev/null || :) (ID: $NUM)" >&2
    exit 0
  fi

  if [[ -f "$FILE_TMP" ]]; then
    echo "=== Removing: $FILE_TMP" >&2
    rm "$FILE_TMP"
  fi

  set "-x"
  curl $IS_SILENT -o "$FILE_TMP" http://bdrm:2110 --max-time "$SECS" || {
    local +x STAT="$?"
    if [[ ! "$STAT" -eq "28" ]]; then
      echo "=== Unknown error from curl: $STAT" >&2
      exit "$STAT"
    fi
  }

  mv -f "$FILE_TMP" "$FILE"
  my_nhk skip "$A_ID"
} # === end function
