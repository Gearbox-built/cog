#!/bin/bash
#
# Cog Sample Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
source_lib "${BASH_SOURCE[0]}" # optional
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
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        exit_cog
      else
        usage "cog sample" "task,another-task,lib"
        exit 1
      fi
      ;;
  esac
}