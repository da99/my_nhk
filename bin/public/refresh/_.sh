
# === {{CMD}}
refresh () {
  cd "$THIS_DIR"
  local +x TMP="tmp/schedules"

  private/nhk.py refresh "$(my_nhk schedule-from-cache)"


} # === end function
