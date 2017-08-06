
# === {{CMD}}  Search String

record-next () {
  if [[ -z "$@" ]]; then
    if lynx --dump "http://whatismyipaddress.com/" | grep "Comcast Cable" ; then
      local +x PATTERN="Rising|Technology|Cherry|Biz Lab|Insight|HOKUSAI|COOL JAPAN|Document|Documentary|Buzz|Focus|Close-up|Inside"
    else
      local +x PATTERN="#TOKYO|Rising|Technology|Supernova|Cherry|Amazing Animals|Biz Lab|Insight|HOKUSAI|SOMEWHERE|COOL JAPAN|UKIYO-E|Doki|Document|Documentary|Buzz|Focus|Melo|Close-up|Inside"
    fi
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
