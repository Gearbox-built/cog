#!/bin/bash
#
# Cog Core Functions
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 11, 2018
#
# HISTORY:
#
# * 2018-03-11 - Params function created
# * 2018-03-06 - First Creation
#
# TODO:
# - update all params parsing to use params_require()
# - update all newly created/passed variables to use params_merge()
#
# ##################################################
#

# Merge Parameters
# Description
#
# @arg --arg Arrrrrg me mateys
# @arg [--arg2] Optional arrrrrg
#
cog::params_merge() {
  message "Nothing to see here..."
}

# Require Parameters
# Description
#
# @arg --arg Arrrrrg me mateys
# @arg [--arg2] Optional arrrrrg
#
cog::params_require() {
  message "Nothing to see here..."
}

# Params
# An easier way to take in parameters
# NOTE: Hypens are converted to underscores for variable names
#
# @arg $1 Array of arguments
#
cog::params() {
  if [[ -z "$1" ]]; then
    error "Please provide a list of params."
  fi

  if [[ -z "$2" ]]; then
    error "Please provide $@."
  fi

  # Build the case statement
  cases=($1)
  case="case \$i in "

  # Loop the provided params
  for i in "${cases[@]}"
  do
    case="${case}--${i}=*) ${i/-/_}=\"\${i#*=}\";; "
  done
  case="${case}esac"

  if [[ $VERBOSE == 3 ]]; then
    echo "$case"
  fi

  # Extract those params
  for i in "$@"
  do
    eval "$case"
  done
}