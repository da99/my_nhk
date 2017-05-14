
# === {{CMD}}  SECONDS  URL  file.name
record () {
  local +x SECS="$1"; shift
  local +x URL="$1"; shift
  local +x FILE_NAME="$1"; shift

  curl --silent -o "$FILE_NAME" "$URL" --max-time "$SECS"
} # === end function
