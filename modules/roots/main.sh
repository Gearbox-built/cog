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
cog::source_lib "${BASH_SOURCE[0]}" # optional
#

#
# Module main
# --------------------------------------------------

roots::main() {
  roots::requirements
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  # TODO: Update this to use cog::module_expose()
  case "$1" in
    -v|--version)
      echo "$ROOTS_MODULE_VERSION"
      cog::exit
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        cog::exit
      else
        usage "cog roots" "sage"
        cog::exit
      fi
      ;;
  esac
}