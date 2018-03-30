
# === {{CMD}}  Search String

record-next () {
  if [[ -z "$@" ]]; then
    local +x PATTERN="Fukuoka|DOCUMENTARY|electronics|tempeh|tofu|Architectural|The Gifted|TECHNOLOGICAL"
    PATTERN="$PATTERN|TOYAMA|SAPPORO|SONGS OF TOKYO|COOL|THEO JANSEN|JAPANOLOGY MINI|CLOSE|BUZZ|SAKAMOTO"
    PATTERN="$PATTERN|JAKARTA|INDO|KUALA|TECHNOLOGY|COOL JAPAN|DOCUMENTARY|MELO"
  else
    local +x PATTERN="$@"
  fi

  my_nhk next-id "$PATTERN" | {
    read -r ID
    [[ -n "$ID" ]] && my_nhk record --silent $ID
  }
} # === end function
