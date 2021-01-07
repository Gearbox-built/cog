#!/bin/bash
#
# Cog rsync Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 27, 2018
#
#
# HISTORY:
#
# * 2018-03-09 - v0.0.1 - First Creation
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

# Setup rsync in .env
#
# @arg optional --url
# @arg optional --user
# @arg optional --pass
# @arg optional --port
#
rsync::init() {
  cog::params "$@" --optional="pass port" --required="url user"

  # Check for env
  envs::load
}

#
# Module main
# --------------------------------------------------

rsync::main() {
  rsync::requirements
  local module
  module=$(basename "$(dirname "${BASH_SOURCE[0]}")")

  case "$1" in
  init)
    rsync::init "${@:2}"
    ;;
  push)
    rsync::push "${@:2}"
    ;;
  pull)
    rsync::pull "${@:2}"
    ;;
  *)
    usage "cog rsync" "init,push,pull"
    cog::exit
    ;;
  esac
}
