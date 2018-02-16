
# === {{CMD}}  Search String

record-next () {
  if [[ -z "$@" ]]; then
    local +x PATTERN="electronics|tempeh|tofu|Architectural|The Gifted|TECHNOLOGICAL|TOYAMA|SAPPORO|SONGS OF TOKYO|J-TRIP|COOL|THEO JANSEN|JAPANOLOGY MINI|CLOSE|BUZZ|SAKAMOTO|JAKARTA|INDO|KUALA|TECHNOLOGY|COOL JAPAN|DOCUMENTARY|MELO"
  else
    local +x PATTERN="$@"
  fi

  my_nhk next-id "$PATTERN" | {
    read -r ID
    [[ -n "$ID" ]] && my_nhk record --silent $ID
  }
} # === end function
