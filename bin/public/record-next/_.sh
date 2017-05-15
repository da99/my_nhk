
# === {{CMD}}  Search String
record-next () {
  my_nhk next-id "$@" | {
    read -r ID
    [[ -n "$ID" ]] && my_nhk record --silent $ID
  }
} # === end function
