
# === {{CMD}}  file-to-run
watch () {
  case "$@" in
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

