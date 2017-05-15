
# === {{CMD}}  ID
is-skip () {
  cd "$THIS_DIR"
  local +x ID="$1"; shift
  local +x FILE="tmp/skips/$ID"

  if [[ ! -f "$FILE" ]]; then
    exit 1
  fi

  local +x MAX_SECS=$((60 * 60 * 24))
  local +x NOW="$(date +"%s")"
  local +x THEN="$(stat -c %Y "$FILE")"
  local +x AGE="$(( NOW - THEN ))"

  if [[ "$AGE" -gt "$MAX_SECS" ]]; then
    rm -f "$FILE"
  fi

  if [[ ! -f "$FILE" ]]; then
    exit 1
  fi
} # === end function
