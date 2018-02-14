#!/bin/bash
#
# Cog Core Functions
# Author: Troy McGinnis
# Company: Gearbox
# Updated: February 13, 2018
#
# HISTORY:
#
# * 2018-02-13 - First Creation
#
# TODO:
# - build out module methods
# - build out lib methods
# - update all modules to use module_expose()
# - update all params parsing to use params_require()
# - update all newly created/passed variables to use params_merge()
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


# Modules
# ##################################################

# Install Module
# Installs an existing cog module
#
# @arg string --name Name of the module
#
cog::module_install() {
  message "Installing ${name}..."
}

# New Module
# Creates a new cog module
#
# @arg string --name Name of the module
#
cog::module_new() {
  message "Creating new module..."
}

# Expose Module Methods
#
# @arg array $1 Name of methods to expose
#
cog::module_expose() {
  message "Nothing to see here..."

  # case "$1" in
  #   -v|--version)
  #     echo "$ROOTS_MODULE_VERSION"
  #     exit_cog
  #     ;;
  #   *)
  #     local lib; lib="${module}::${1}::main"

  #     if [[ $(type -t "$lib") == 'function' ]]; then
  #       "$lib" "${@:2}"
  #       exit_cog
  #     else
  #       usage "cog roots" "sage"
  #       exit_cog
  #     fi
  #     ;;
  # esac
}

# New Lib
# Creates a new cog module lib
#
# @arg --name Name of the lib
# @arg [--module] Name of the module
#
cog::lib_new() {
  message "Creating new lib..."
}

# Expose Module Library Methods
#
# @arg array $1 Name of methods to expose
#
cog::lib_expose() {
  message "Nothing to see here..."

  # case "$1" in
  #   install)
  #     roots::sage::install "${@:2}"
  #     ;;
  #   *)
  #     usage "cog roots sage" "install"
  #     exit_cog
  # esac
}


# Parameters
# ##################################################

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