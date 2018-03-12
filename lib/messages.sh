#!/bin/bash
#
# Cog Messages
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#
# HISTORY:
#
# * 2017-11-19 - First Creation
#
# ##################################################
#

# Usage Message for Modules
# Creates new salts and updates the provided or default file
#
# @arg    string  $1   Usage base command (eg. cog util)
# @arg    array   $2   Sub commands (eg. salts,random_key) (format: csv)
# @arg    string  [$3] Sub command pre-message (eg. arg) (default: or)
# @return string  Usage
#
usage() {
  local usages; local i; local label;
  IFS=',' read -r -a usages <<< "$2"

  label="${3:-or}:"

  # New line
  echo

  if [[ -n $1 ]]; then
    printf "${YELLOW}Usage:${NC}\n"
    printf "${1} "
  fi

  local len="$((${#1}-${#label}))"

  for i in "${!usages[@]}"
  do
    if [[ $i -eq 0 ]]; then
      printf "${usages[i]}\n";
    else
      printf '%0.s ' $(seq 1 $len)
      printf "%s %s\n" "$label" "${usages[i]}"
    fi
  done

  # New line
  echo
}

# Warning Message
#
# @arg    string  [$1] Warning message to display (default: Warning)
# @return string  Message
#
warning() {
  if [[ -z "$1" ]]; then
    printf "\n${YELLOW}Warning${NC}\n\n"
  else
    printf "\n${YELLOW}Warning:${NC} ${1}\n\n"
  fi
}

# Warning Message with y/n check
#
# @arg    string  [$1] Warning message to display (default: Warning)
# @return mixed   Message or exit
#
warning_check() {
  if [[ -z "$1" ]]; then
    printf "\n${RED}WARNING${NC}\n\n"
  else
    printf "\n${RED}WARNING:${NC} ${1}\n\nDo you want to continue? ${YELLOW}(y/n)${NC} "
  fi
  read -r check

  if [[ "$check" == "y" || "$check" == "Y" ]]; then
    return 0
  else
    cog::exit
  fi
}

# Error Message
#
# @arg    string  [$1] Error message to display (default: Error)
# @arg    boolean [$2] Exit after message (default: true)
# @return string  Message
#
error() {
  if [[ -z "$1" ]]; then
    printf "\n${YELLOW}Error${NC}\n\n"
  else
    printf "\n${RED}Error:${NC} ${1} Exiting.\n\n"

    if [[ -z "$2" || "$2" != false ]]; then
      cog::exit
    fi
  fi
}

# Header Message
#
# @arg    string $1 Header to display
# @arg    string [$2] Non-green messaging to display following header
# @return string Message
#
header() {
  if [[ -n "$1" ]]; then
    printf "\n--------------------------------------------------------"
    printf "\n${GREEN}%s${NC} %s" "$1" "$2"
    printf "\n--------------------------------------------------------\n"
  fi
}

# Debug Header
#
# @arg    string $1 Header to display
# @return string Message
#
debug_header() {
  if [[ -n "$1" ]]; then
    printf "\n--------------------------------------------------------"
    printf "\n${YELLOW}%s${NC}" "$1"
    printf "\n--------------------------------------------------------\n"
  fi
}

# Debug Message
#
# @arg    string $1 Message to display
# @return string Message
#
debug() {
  if [[ -n "$1" ]]; then
    printf "${GRAY}%s:${NC} %s\n" "$1" "$2"
  fi
}

# Standard Message
#
# @arg    string $1 Message to display
# @return string Message
#
message() {
  if [[ -n "$1" ]]; then
    printf "\n${BLUE}${1}${NC}\n"
  fi
}

# Success Message
#
# @arg    string $1 Success message to display
# @return string Message
#
success() {
  if [[ -n "$1" ]]; then
    printf "\n${GREEN}Success:${NC} ${1}\n"
  fi
}
