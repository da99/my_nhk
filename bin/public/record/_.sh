
# === {{CMD}}  ID
# === {{CMD}}  --silent ID
record () {
  local +x IS_SILENT=""
  if [[ "$@" == *"silent"* ]]; then
    local +x IS_SILENT="--silent"
    shift
  fi

  local +x NUM="$1"; shift
  local +x INFO="$(my_nhk record-info $NUM || :)"
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

  sleep "$WAIT_TIME"

  curl $IS_SILENT -o "$FILE" http://bdrm:2110 --max-time "$SECS"
} # === end function
