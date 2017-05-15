
# === {{CMD}}  ID
skip () {
  cd "$THIS_DIR"
  local +x ID="$1"; shift
  mkdir -p tmp/skips
  my_nhk desc "$ID" > tmp/skips/$ID
} # === end function
