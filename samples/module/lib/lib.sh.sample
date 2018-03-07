#!/bin/bash
#
# Sample Lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

sample::lib_task() {
  echo "Lib"
}

sample::lib_another-task() {
  for i in "$@"
  do
    case $i in
      --arg1=*)
        local arg1="${i#*=}"
        ;;
      --arg2=*)
        local arg2="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$arg1" ]]; then
    usage "cog sample sample-lib" "lib-task, --arg1=<arg1>,[--arg2=<arg2>]" "arg"
    cog::exit
  fi

  echo "More lib"
  echo "Arg #1: $arg1"
  echo "Arg #2: $arg2"
}


#
# Lib main
# --------------------------------------------------

sample::lib::main() {
  case "$1" in
    lib-task)
      server::lib_task "${@:2}"
      ;;
    lib-another-task)
      server::lib_another-task "${@:2}"
      ;;
    *)
      usage "cog sample lib" "lib-task,lib-another-task --arg1=<arg1> [--arg2=<arg2>]"
      cog::exit
  esac
}