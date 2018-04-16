
# === {{CMD}}  Search String

record-next () {
  local +x ID="$(my_media nhk next-favorite-id)"
  [[ -n "$ID" ]] && my_nhk record --silent $ID
} # === end function
