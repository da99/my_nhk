#!/usr/bin/env mksh
#
#
set -u -e -o pipefail


PATH="$PATH:../my_nhk/bin"
PATH="$PATH:../sh_color/bin"

ALL_PASSED="true"

failed () {
  local STAT="$?"
  sh_color RED "!!! {{FAILED}}: status $STAT"
  exit $STAT
  ALL_PASSED=""
}

run () {
  local +x TEXT="$@"
  sh_color ORANGE "=== {{$TEXT}}"
  "$@" || failed
}

run my_nhk schedule-download
run my_nhk schedule-from-cache
run my_nhk schedule-is-fresh
run my_nhk schedule-refresh
run my_nhk schedule
run my_nhk titles
run my_nhk title
run my_nhk title next
run my_nhk title $(my_nhk titles | head -n4 | tail -n1 | cut -d':' -f1)
run my_nhk seconds-left


if [[ -z "$ALL_PASSED" ]] ; then
  sh_color RED "!!! {{FAILs}}"
else
  sh_color GREEN "=== All {{PASSED}}."
fi
