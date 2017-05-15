
# === {{CMD}}
install () {
  cd "$THIS_DIR"
  local +x IFS=$'\n'
  for DIR in $( find "$PWD"/sv -maxdepth 1 -mindepth 1 -type d | sort) ; do
    local +x NAME="$(basename "$DIR")"
    local +x TARGET="/var/service/$NAME"
    if [[ -e "$TARGET" ]]; then
      echo "=== Already installed: $TARGET"
    else
      echo "=== Installing: $TARGET"
      sudo ln -s "$DIR" "$TARGET"
    fi
  done
} # === end function
