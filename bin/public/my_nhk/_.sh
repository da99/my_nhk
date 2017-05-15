
# === {{BIN}}  --json
# === {{BIN}}  titles          # Prints: NUM TITLE : SUBTITLE
# === {{BIN}}  desc        [ID]
# === {{BIN}}  record-info [ID] # Prints: START SECONDS  UNIQ_ID
# === {{BIN}}  current
# === {{BIN}}  next    [Search String]
# === {{BIN}}  next-id Search String
my_nhk () {
  cd "$THIS_DIR"
  case "$@" in
    "--json")
      "$THIS_DIR"/private/nhk.py "$@"
      ;;

    "next-id "*)
      unset -f my_nhk
      shift
      local +x TARGET="$@"
      set +o pipefail
      my_nhk titles | grep -i "$TARGET" | head -n1 | cut -d':' -f1
      ;;

    "next "*)
      unset -f my_nhk
      shift
      my_nhk next-id "$@" | {
        read -r ID
        my_nhk desc $ID
      }
      ;;

    desc|record-info)
      unset -f my_nhk
      the_action="$1"; shift
      my_nhk titles | fzy | cut -d':' -f1 | {
        read -r the_id
        my_nhk $the_action $the_id
      }
      ;;

    *)
      mkdir -p tmp
      my_nhk --json > tmp/nhk.json
      if [[ ! -s tmp/prev.json ]]; then
        cp -f tmp/nhk.json tmp/prev.json
      fi
      sh_color BOLD "$("$THIS_DIR"/private/nhk.py tmp/ "$@")"
      cp -f tmp/nhk.json tmp/prev.json
      ;;
  esac
} # === end function

