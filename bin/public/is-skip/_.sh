
# === {{CMD}}  ID
is-skip () {
  cd "$THIS_DIR"
  local +x ID="$1"; shift
  local +x LIST="/play/nhk/list.txt"
  local +x FILENAME="$(my_nhk meta-record $ID | cut -d' ' -f3)"

  if [[ ! -z "$FILENAME" ]] ; then
    if grep "$FILENAME" "$LIST" >/dev/null ; then
      exit 0
    fi
  fi
  exit 1
} # === end function
