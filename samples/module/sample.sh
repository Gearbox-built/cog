#!/bin/bash
#
# Cog Sample Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#
SAMPLE_MODULE_VERSION="0.0.1"
#
# HISTORY:
#
# * 2018-02-13 - v0.0.2 - Added version number
# * 2017-11-19 - v0.0.1 - First Creation
#
# ##################################################
#
cog::source_lib "${BASH_SOURCE[0]}" # optional
#

sample::task() {
  echo "Do things"
}

sample::another-task() {
  echo "Do other things"
}

#
# Module main
# --------------------------------------------------

sample::main() {
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    task)
      project::push "${@:2}"
      ;;
    another-task)
      project::pull "${@:2}"
      ;;
    -v|--version)
      echo "$SAMPLE_MODULE_VERSION"
      cog::exit
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        cog::exit
      else
        usage "cog sample" "task,another-task,lib"
        cog::exit
      fi
      ;;
  esac
}