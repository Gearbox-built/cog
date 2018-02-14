#!/bin/bash
#
# Cog Roots Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: February 13, 2018
#
ROOTS_MODULE_VERSION="0.0.1"
#
# HISTORY:
#
# * 2018-02-13 - v0.0.1 - First creation
#
# ##################################################
#
source_lib "${BASH_SOURCE[0]}" # optional
#

#
# Module main
# --------------------------------------------------

roots::main() {
  roots::requirements
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    -v|--version)
      echo "$ROOTS_MODULE_VERSION"
      exit_cog
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        exit_cog
      else
        usage "cog roots" "sage"
        exit_cog
      fi
      ;;
  esac
}