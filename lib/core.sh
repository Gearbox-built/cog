#!/bin/bash
#
# Cog Core Functions
# Author: Troy McGinnis
# Company: Gearbox
# Updated: April 4, 2018
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
  local requirements; requirements=(bpkg)

  for i in "${requirements[@]}"; do
    cog::check_requirement "${i}"
  done
}

# Exit
# Checks for updates then exits the script
#
cog::exit() {
  if [[ -n "$CHECK_UPDATES" ]]; then
    cog::check_for_updates
  fi
  exit 1
}

# Source Modules
# Load all of the cog modules
#
# TODO: Register/track modules to provide better feedback
cog::source_modules() {

  # Source script files
  for module_dir in ${COG_PATH}/deps/*; do
    module=${module_dir##*/}

    if [[ -d "$module_dir" && -f "${module_dir}/${module}.sh" ]]; then
      MODULES+=("${module//cog-}")

      # source module shell script
      source "${module_dir}/${module}.sh"

      # source module config
      local module_config
      module_config=${module_dir}/.config

      # if there's a config and it's opted to load now, source it now
      if [ -f "$module_config" ]; then
        if [[ $(sed -n '2{p;q;}' "$module_config") == "# config-load" ]]; then
          source "${module_dir}/.config"
        fi
      fi
    fi
  done
}

# Source Lib
# Batch source module lib bash files
#
# @arg string $1 Directory to source bash files
#
cog::source_lib() {
  local file; file=${1:-${BASH_SOURCE[1]}}

  if [[ -n "$file" && -f "$file" ]]; then
    local lib; local lib_dir; lib_dir="$( cd "$( dirname "${file}" )" && pwd )/lib"

    if [[ -d $lib_dir ]]; then
      for lib in ${lib_dir}/*; do source "$lib"; done
    fi
  fi
}

# List Libs
# List all the libs for a module
#
# @arg string $1 Directory to find lib files
#
cog::list_libs() {
  local file; file=${1:-${BASH_SOURCE[1]}}

  if [[ -n "$file" && -f "$file" ]]; then
    local lib; local lib_dir; lib_dir="$( cd "$( dirname "${file}" )" && pwd )/lib"

    if [[ -d $lib_dir ]]; then
      for lib in ${lib_dir}/*;
      do
        lib_name=$(echo "${lib##*/}" | cut -f 1 -d '.')
        if [[ "$lib_name" != 'requirements' ]]; then
          echo "$lib_name"
        fi
      done
    fi
  fi
}