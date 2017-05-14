
# === {{CMD}}  II:MM  SECS  URL  FILENAME
record-at () {
  local +x TIME="$1"; shift
  local +x SECS="$1"
  local +x URL="$2"
  local +x FILENAME="$3"

  now () {
    date +"%H:%M"
  }

  while [[ "$(now)" != "$TIME" ]] ; do
    sleep 5
  done

  if [[ "$(now)" == "$TIME" ]]; do
    my_video record "$SECS" "$URL" "$FILENAME"
  else
    echo "!!! Recording did not occur." >&2
    exit 2
  done
} # === end function
