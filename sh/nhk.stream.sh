#!/bin/env zsh
#
# Example:
#
#   nhk.stream.sh low 2111
#   nhk.stream.sh high 2111
#
set -u -e -o pipefail -x

local +x DEFINITION="$1"; shift
local +x PORT="$1"; shift
local +x FILE="http://www3.nhk.or.jp/nhkworld/app/tv/hlslive_tv.xml"
local +x M3U8="$(curl --silent "$FILE" | grep -Pzo "(?s)<${DEFINITION}_url>.+?<wstrm>\K(.+?)(?=</ws)" | tr -d '\000'|| :)"

if [[ -z "$M3U8" ]]; then
  echo "--- Could not retrieve: file: $FILE"
  exit 1
fi

# File from:
# http://www3.nhk.or.jp/nhkworld/app/tv/hlslive_tv.xml
exec streamlink                  \
  --http-no-ssl-verify            \
  --player-external-http           \
  --player-external-http-port $PORT \
  "hlsvariant://$M3U8 name_key=bitrate"  best


