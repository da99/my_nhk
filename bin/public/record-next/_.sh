
# === {{CMD}}  Search String

record-next () {
  local +x COMMON="Shoot|Hokusai|Miracle|DOMO|COOL|Regional|mini"
  if [[ -z "$@" ]]; then
    if lynx --dump "http://whatismyipaddress.com/" | grep "Comcast Cable" ; then
      local +x PATTERN="$COMMON|Kuala|Rising|Technology|Cherry|Biz Lab|Insight|HOKUSAI|COOL JAPAN|Document|Documentary|Buzz|Focus|Close-up|Inside|MELO"
    else
      local +x PATTERN="$COMMON|#TOKYO|Kuala|Rising|Technology|Supernova|Cherry|Amazing Animals|Biz Lab|Insight|HOKUSAI|SOMEWHERE|COOL JAPAN|Doki|Document|Documentary|Buzz|Focus|Melo|Close-up|Inside"
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
