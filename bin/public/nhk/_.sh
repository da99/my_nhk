
# === {{CMD}}
# === {{CMD}}  --file
# === {{CMD}}  titles        # Prints: NUM TITLE : SUBTITLE
# === {{CMD}}  desc      NUM
# === {{CMD}}  record-at NUM # Prints: START SECONDS
# === {{CMD}}  desc
# === {{CMD}}  current
# === {{CMD}}  next
nhk () {
  cd "$THIS_DIR"
  if [[ "$@" == "--file" ]]; then
    "$THIS_DIR"/private/nhk.py "$@"
    return 0
  fi

  mkdir -p tmp
  nhk --file > tmp/nhk.json
  "$THIS_DIR"/private/nhk.py tmp/nhk.json "$@"
} # === end function

