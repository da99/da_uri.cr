
# === {{CMD}}
watch () {
  PATH="$PATH:$THIS_DIR/../sh_color/bin"
  source "$THIS_DIR/dev/paths.sh"

  if [[ ! -z "$@" ]]; then
    echo "=== Compiling... $(date "+%H:%M:%S") ..." >&2
    bin/mu-html spec compile
    sleep 0.5
    OUTPUT_DIR="$THIS_DIR/tmp/spec/output"

    SPEC_BIN_PATH="$(bin/mu-html spec bin-path)"
    IFS=$'\n'
    for SPEC_DIR in $(find -L "spec" -mindepth 1 -maxdepth 1 -type d | sort --human-numeric-sort); do
      sh_color YELLOW "=== Running: {{$SPEC_DIR}}"
      rm    -rf "$OUTPUT_DIR"
      mkdir -p "$OUTPUT_DIR"
      "$SPEC_BIN_PATH" --output "$OUTPUT_DIR" --file "$SPEC_DIR"/input/input.json
      bin/mu-html spec dirs-must-match "$SPEC_DIR"/output "$OUTPUT_DIR"
    done
    echo "============================================="
    echo ""

  else
    PATH="$PATH:$THIS_DIR/../mksh_setup/bin"
    PATH="$PATH:$THIS_DIR/bin"
    if ! type crystal &>/dev/null; then
      echo "!!! Crystal not found in path." >&2
      exit 2
    fi
    "$(basename "$THIS_DIR")" watch run || :
    mksh_setup watch "-r src -r spec -r bin" "$(basename "$THIS_DIR") watch run"
  fi

} # === end function

