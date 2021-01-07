#!/bin/bash
#
# Cog Envs Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: January 29, 2020
#
#
# HISTORY:
#
# * 2020-01-29 - v0.0.1 - First Creation
#
# ##################################################
#
if [[ ! "${#BASH_SOURCE[@]}" -gt 0 ]] || [[ "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]##*/}" != 'cog' ]]; then
  echo 'Module must be executed through cog.'
  return || exit
fi
#
cog::source_lib "${BASH_SOURCE[0]}"
#

# Check WP CLI
# Checks that WP CLI is up to date
#
# @arg optional --file File that contains salts to be updated (default: wp-config.php)
#
envs::load() {
  env_file="${PWD}/.env"
  if [[ -f $env_file ]]; then
    message "Loading .env file..."
    source $env_file
  else
    warning "Can't find .env file."
  fi
}
