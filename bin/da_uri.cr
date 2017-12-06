#!/usr/bin/env zsh
#
#
set -u -e -o pipefail

local +x THE_ARGS="$@"
local +x THIS_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
local +x THIS_NAME="$(basename "$THIS_DIR")"

local +x ACTION="[none]"
if [[ ! -z "$@" ]]; then
  ACTION="$1"; shift
fi

PATH="$PATH:$THIS_DIR/../process/bin"
PATH="$PATH:$THIS_DIR/../my_zsh/bin"
PATH="$PATH:$THIS_DIR/../my_crystal/bin"
PATH="$PATH:$THIS_DIR/../sh_color/bin"
PATH="$PATH:$THIS_DIR/bin"

case $ACTION in

  help|--help|-h)
    my_zsh print-help $0 "$@"
    ;;

  *)
    # === Check sh/:
    local +x SHELL_SCRIPT="$THIS_DIR/sh/${ACTION}"/_
    if [[ -s  "$SHELL_SCRIPT"  ]]; then
      source "$SHELL_SCRIPT"
      exit 0
    fi

    # === It's an error:
    echo "!!! Unknown action: $ACTION" 1>&2
    exit 1
    ;;

esac
