
# === {{CMD}}  [ID]
record () {
  local +x NUM="$@"
  local +x INFO="$(my_nhk record-info $NUM || :)"
  if [[ -z "$INFO" ]]; then
    exit 2
  fi

  set $INFO
  local +x STARTS="$1"
  local +x SECS="$2"
  local +x FILE="/tmp/nhk.$3.raw"
  local +x A_ID="$4"
  local +x NOW="$(date +"%s")"
  local +x WAIT_TIME="$(($STARTS - $NOW))"
  local +x MINS="$(( WAIT_TIME / 60))"
  sh_color BOLD "$(my_nhk desc "$A_ID")"
  echo "$FILE"
  local +x COUNTER="0"
  while [[ "$COUNTER" -lt "$WAIT_TIME" ]]; do
    COUNTER="$(( COUNTER + 1 ))"
    local +x COUNTER_MINS=$(( (WAIT_TIME - COUNTER)/60 ))
    echo -en "\r=== Starts in: $(( (WAIT_TIME - COUNTER)/60 )) mins. "
    echo -n "$(( (WAIT_TIME - COUNTER - (COUNTER_MINS * 60)) )) secs. "
    sleep 1
  done
  echo -e "\r                                 "

  curl -o "$FILE" http://bdrm:2112 --max-time "$SECS"
} # === end function
