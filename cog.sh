#!/bin/bash

# ##################################################
#
# Cog
# Author: Troy McGinnis
# Company: Gearbox
# URI: https://gearboxbuilt.com
# Updated: March 6, 2018
#
#
NAME='cog'
VERSION="1.0.0"
#
# HISTORY:
#
# * 2018-02-13 - v1.0.0 - Cog refactor
#
# ##################################################

SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

#
# Source Script files
# --------------------------------------------------

# TODO: Register/track modules to provide better feedback
source_modules() {

  # Source script files
  for module in ${SCRIPT_PATH}/modules/*; do

    if [ -d "$module" ]; then
      # source module shell script
      source "${module}/main.sh"

      # source module config
      local module_config
      module_config=${module}/.config

      # if there's a config and it's opted to load now, source it now
      if [ -f "$module_config" ]; then
        if [[ $(sed -n '2{p;q;}' "$module_config") == "# config-load" ]]; then
          source "${module}/.config"
        fi
      fi
    fi
  done

  source "${SCRIPT_PATH}/.config"
  source "${SCRIPT_PATH}/.colors"
}


#
# Cog
# --------------------------------------------------

source "${SCRIPT_PATH}/lib/core.sh"
source "${SCRIPT_PATH}/lib/updates.sh"
source "${SCRIPT_PATH}/lib/usage.sh"
source "${SCRIPT_PATH}/lib/messages.sh"
source "${SCRIPT_PATH}/lib/modules.sh"
source "${SCRIPT_PATH}/lib/params.sh"

cog::main "$@"
