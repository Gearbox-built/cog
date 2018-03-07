#!/bin/bash
#
# Cog Core Functions
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 6, 2018
#
# HISTORY:
#
# * 2018-02-13 - First Creation
#
# ##################################################
#

# Check Requirement
# Performs a basic check on a binary to see if it is accessible or not
#
# @arg string $1 Binary to check (eg. npm)
#
cog::check_requirement() {
  if [[ -z "$1" ]]; then
    error "Please provide a binary to check."
  fi

  if [[ "$(which "${1}")" == "" ]]; then
    error "Please ensure ${YELLOW}${1}${NC} is installed before continuing."
  fi
}

# Check Base Cog Requirements
# Performs a check on cog's basic needs
#
cog::check_base_requirements() {
  local requirements; requirements=(npm yarn bower rvm)

  for i in "${requirements[@]}"; do
    cog::check_requirement "${i}"
  done
}

# Exit
# Checks for updates then exits the script
#
cog::exit() {
  check_for_updates
  exit 1
}

# Source Lib
# Batch source module lib bash files
#
# @arg string $1 Directory to source bash files
#
cog::source_lib() {
  if [[ -n "$1" && -f "$1" ]]; then
    local lib; local lib_dir; lib_dir="$( cd "$( dirname "${1}" )" && pwd )/lib"

    if [[ -d $lib_dir ]]; then
      for lib in ${lib_dir}/*; do source "$lib"; done
    fi
  fi
}

#
# Main
# --------------------------------------------------

cog::main() {
  source_modules

  # Check requirements
  cog::check_base_requirements

  # Check for no params
  if [[ $# -lt 1 ]]
    then
      cog_usage
      cog::exit
  fi

  #
  # Handle args and such
  # aka: run
  #
  while (( $# >= 1 ))
  do
  key="$1"

  case $key in
    --dev)
      DEV=YES
      ;;
    --debug)
      DEBUG=YES
      ;;
    -v|--version)
      echo $VERSION
      cog::exit
      ;;
    ?|--help)
      cog_usage
      cog::exit
      ;;
    update|upgrade)
      update_self
      cog::exit
      ;;
    pull)
      project::pull "${@:2}"
      cog::exit
      ;;
    push)
      project::push "${@:2}"
      cog::exit
      ;;
    update)
      project::update "${@:2}"
      cog::exit
      ;;
    --*)
      # Hmm...
      ;;
    *)
      if [[ $(type -t "${1}::main") == 'function' ]]; then
        "${1}::main" "${@:2}"
        cog::exit
      fi
      ;;
  esac
  shift # past argument or value
  done
}
