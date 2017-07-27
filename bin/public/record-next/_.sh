
# === {{CMD}}  Search String

record-next () {
  if [[ -z "$@" ]]; then
    local +x PATTERN="#TOKYO|Rising|Technology|Supernova|Cherry|Amazing Animals|Biz Lab|Insight|HOKUSAI|SOMEWHERE|COOL JAPAN|UKIYO-E|Doki|Document|Documentary|Buzz|Focus|Melo|Close-up|Inside"
    # case "$(date +"%I:%M")" in
    #   "06:59") # Record NEWSLINE every 12 hours
    #     PATTERN="NEWSLINE|$PATTERN"
    #     ;;
    # esac

  else
    local +x PATTERN="$@"
  fi

  my_nhk next-id "$PATTERN" | {
    read -r ID
    [[ -n "$ID" ]] && my_nhk record --silent $ID
  }
} # === end function
