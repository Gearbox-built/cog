#!/bin/bash

# ##################################################
#
# Cog
# Author: Troy McGinnis
# Company: Gearbox
# URI: https://gearboxbuilt.com
# Updated: March 6, 2018
#
#
NAME='cog'
VERSION="1.0.0"
#
# HISTORY:
#
# * 2018-02-13 - v1.0.0 - Cog refactor
#
# ##################################################

MODULES=()
COG_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

#
# Cog
# --------------------------------------------------

# Cog libs
source "${COG_PATH}/lib/core.sh"
source "${COG_PATH}/lib/updates.sh"
source "${COG_PATH}/lib/usage.sh"
source "${COG_PATH}/lib/messages.sh"
source "${COG_PATH}/lib/modules.sh"
source "${COG_PATH}/lib/params.sh"

# Cog config + colors
source "${COG_PATH}/.config"
source "${COG_PATH}/.colors"

#
# Main
# --------------------------------------------------

cog() {
  cog::source_modules

  # Check requirements
  cog::check_base_requirements

  # Check for no params
  if [[ $# -lt 1 ]]
    then
      cog::usage
      cog::exit
  fi

  # Handle args and such
  while (( $# >= 1 ))
  do
  key="$1"

  case $key in
    --debug)
      DEBUG=YES
      ;;
    -v)
      VERBOSE=1
      ;;
    -vv)
      VERBOSE=2
      ;;
    -vvv)
      VERBOSE=3
      ;;
    --version)
      echo $VERSION
      exit 1
      ;;
    ?|-h|--help)
      cog::usage
      cog::exit
      ;;
    update|upgrade)
      cog::update
      exit 1
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

# GO!
cog "$@"
