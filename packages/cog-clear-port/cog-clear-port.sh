#!/bin/bash
#
# Cog clear port
# Author: Troy McGinnis
# Company: Gearbox
# Updated: December 8, 2020
#
#
# HISTORY:
#
# * 2020-12-08 - v0.0.1 - First Creation
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

# Clear Port
#
# @arg $1 Port to be cleared
#
clear-port::main() {
  # cog::params "$@" --optional="pass port" --required="url user"
  lsof -ti tcp:"$1" | xargs kill
}
