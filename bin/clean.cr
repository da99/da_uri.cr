#!/usr/bin/env mksh
#
#
set -u -e -o pipefail

local +x THE_ARGS="$@"
local +x THIS_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

local +x ACTION="[none]"
if [[ ! -z "$@" ]]; then
  ACTION="$1"; shift
fi

PATH="$PATH:$THIS_DIR/../mksh_setup/bin"
PATH="$PATH:$THIS_DIR/../my_crystal/bin"
PATH="$PATH:$THIS_DIR/../sh_color/bin"
PATH="$PATH:$THIS_DIR/bin"

case $ACTION in

  help|--help|-h)
    mksh_setup print-help $0 "$@"
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
