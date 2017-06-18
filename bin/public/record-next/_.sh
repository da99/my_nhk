
# === {{CMD}}  Search String

record-next () {
  if [[ -z "$@" ]]; then
    local +x PATTERN="Rising|Technology|Supernova|Cherry|Amazing Animals|Biz Lab|Insight|HOKUSAI|SOMEWHERE|COOL JAPAN|UKIYO-E|Doki|Document|Documentary|Buzz|Focus|Melo|Newsroom|Close-up|Inside"
  else
    local +x PATTERN="$@"
  fi

  my_nhk next-id "$PATTERN" | {
    read -r ID
    [[ -n "$ID" ]] && my_nhk record --silent $ID
  }
} # === end function
