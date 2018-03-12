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
# @arg $1 Required params
# @arg $2 Optional params
#
cog::params_require() {
  if [[ $VERBOSE == 3 ]]; then
    debug_header "${FUNCNAME[0]}"
    debug 'params' "$@"
  fi

  local optional; optional=()
  local required; required=($1)
  local required_num; required_num=${#required[@]}
  local function_name; function_name="${FUNCNAME[1]}"

  if [[ -n "$2" ]]; then
     optional=($2)
  fi

  if [[ "${FUNCNAME[1]}" == 'cog::params' ]]; then
    function_name="${FUNCNAME[2]}"
  fi

  if [[ $VERBOSE == 3 ]]; then
    debug 'initial function' "$function_name"
  fi

  # Construct usage statement
  local function_array; function_array=(${function_name/::/ })
  local function_usage; function_usage="usage \"cog"
  local count; count=0;
  local total; total=${#function_array[@]}

  # Usage functions
  for i in "${function_array[@]}"
  do
    ((count++))
    if [[ $count -eq total ]]; then
      function_usage="${function_usage}\" \"${i}"
    else
      function_usage="${function_usage} ${i}"
    fi
  done

  # Usage required
  for i in "${required[@]}"
  do
    function_usage="${function_usage}, --${i}=<${i}>"
  done

  # Usage optional
  for i in "${optional[@]}"
  do
    function_usage="${function_usage},[--${i}=<${i}>]"
  done
  function_usage="${function_usage}\" \"args\""

  # Check
  local required_check; required_check="if [[ \"\$#\" -lt $required_num "
  for i in "${required[@]}"
  do
    required_check="${required_check} || -z \"\$${i}\""
  done
  required_check="${required_check} ]]; then ${function_usage}; fi"

  if [[ $VERBOSE == 3 ]]; then
    debug 'required check' "$required_check"
  fi

  eval "$required_check"
}

# Params
# An easier way to take in parameters
# NOTE: Hypens are converted to underscores for variable names
#
# @arg $1 All params
# @arg --optional Array string of optional arguments
# @arg [--required] Array string of required arguments
#
cog::params() {
  if [[ $VERBOSE == 3 ]]; then
    debug_header "${FUNCNAME[0]}"
    debug "params" "$@"
  fi

  for i in "$@"
  do
    case $i in
      --optional=*)
        local optional="${i#*=}"
        ;;
      --required=*)
        local required="${i#*=}"
        ;;
    esac
  done

  if [[ -z "$optional" ]]; then
    error "cog::params error: Missing params."
    cog::exit
  fi

  # Build the case statement
  cases=($required $optional)
  case="case \$i in "

  # Loop the provided params
  for i in "${cases[@]}"
  do
    case="${case}--${i}=*) ${i/-/_}=\"\${i#*=}\";; "
  done
  case="${case}esac"

  if [[ $VERBOSE == 3 ]]; then
    debug "case eval" "$case"
  fi

  # Extract those params
  for i in "$@"
  do
    eval "$case"
  done

  # Check required fields
  if [[ -n "$required" ]]; then
    cog::params_require "$required" "$optional"
  fi
}