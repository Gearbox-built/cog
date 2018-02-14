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
# ##################################################
#

# Check Requirement
# Performs a basic check on a binary to see if it is accessible or not
#
# @arg $1 Binary to check (eg. npm)
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
# @arg --name Name of the module
#
cog::module_install() {
  message "Installing ${name}..."
}

# New Module
# Creates a new cog module
#
# @arg --name Name of the module
#
cog::module_new() {
  message "Creating new module..."
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