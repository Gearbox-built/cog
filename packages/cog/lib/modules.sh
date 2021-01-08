#!/bin/bash
#
# Cog Core Functions
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 6, 2018
#
# HISTORY:
#
# * 2018-03-06 - First Creation
#
# TODO:
# - build out module methods
# - build out lib methods
# - update all modules to use module_expose()
#
# ##################################################
#

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
  #     cog::exit
  #     ;;
  #   *)
  #     local lib; lib="${module}::${1}::main"

  #     if [[ $(type -t "$lib") == 'function' ]]; then
  #       "$lib" "${@:2}"
  #       cog::exit
  #     else
  #       usage "cog roots" "sage"
  #       cog::exit
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
  #     cog::exit
  # esac
}
