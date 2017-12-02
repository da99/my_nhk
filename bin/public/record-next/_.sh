
# === {{CMD}}  Search String

record-next () {
  local +x COMMON="COOL|JAPANOLOGY mini"
  if [[ -z "$@" ]]; then
    # if lynx --dump "http://whatismyipaddress.com/" | grep "Comcast Cable" ; then
      local +x PATTERN="$COMMON|Jakarta|Indo|Kuala|Technology|COOL JAPAN|Documentary|MELO"
    # else
    #   local +x PATTERN="$COMMON|Kuala|Technology|COOL JAPAN|Documentary|MELO"
    # fi
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
