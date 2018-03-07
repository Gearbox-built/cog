#!/bin/bash
#
# Roots Sage Lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: February 13, 2018
#

roots::sage::install() {
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
    usage "cog roots sage" "install, --arg1=<arg1>,[--arg2=<arg2>]" "arg"
    cog::exit
  fi

  message "Setting up Roots Sage..."

  # 1. cd wp-content/themes
  # 2. composer create-project roots/sage bambora dev-master
  # 3. cd $project-name
  # 4. yarn
  # 5. update resources/assets/config.json "devUrl"
}


#
# Lib main
# --------------------------------------------------

roots::sage::main() {
  case "$1" in
    install)
      roots::sage::install "${@:2}"
      ;;
    *)
      usage "cog roots sage" "install"
      cog::exit
  esac
}