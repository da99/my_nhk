
# === {{CMD}}  file-to-run
watch () {
  case "$@" in
    nhk.py)
      cd "$THIS_DIR"
      mkdir -p tmp
      my_video nhk --json > tmp/nhk.json
      cat tmp/nhk.json

      set "-x"
      my_video nhk titles
      my_video nhk desc 0
      my_video nhk record-at 0
      my_video nhk current
      my_video nhk next
    ;;

    private/nhk.py)
      CMD="my_video watch nhk.py"
      $CMD || :
      mksh_setup watch "-r bin -r private" "$CMD"
    ;;

    *)
      if [[ ! -f "$1" ]]; then
        sh_color RED "!!! {{Invalid options}}: $@"
        exit 2
      fi

      local +x FILE="$1"; shift
      "$FILE" || :
      mksh_setup watch "-r bin -r private" "$FILE"
      ;;
  esac
} # === end function

