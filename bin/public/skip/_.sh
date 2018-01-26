
# === {{CMD}}  ID
skip () {
  local +x FILENAME="$(my_nhk record-info $1 | cut -d' ' -f3)"
  local +x LIST="/play/nhk/list.txt"
  if [[ ! -z "$FILENAME" ]] ; then
    if ! grep "$FILENAME" "$LIST" >/dev/null ; then
      echo nhk.$FILENAME.mp4 >> "$LIST"
    fi
    echo nhk.$FILENAME.mp4
  else
    exit 2
  fi
} # === end function
