#!/bin/bash
#
# Cog Usage
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 6, 2018
#
# HISTORY:
#
# * 2018-03-06 - Modules list update
# * 2017-11-19 - First Creation
#
# ##################################################
#

# Usage
#
cog::usage() {
  printf "\n--------------------------------------------------------\n"
  printf "${BLUE}%s${NC}\n" "Cog"
  printf "${GRAY}v%s${NC}" "$VERSION"
  printf "\n--------------------------------------------------------\n\n"
  printf "${WHITE}Usage:${NC} \n"
  printf "${NAME} <module|command>\n"
  printf "\n${WHITE}Modules:${NC} \n"

  # What we got?
  if [[ "${#MODULES[@]}" -gt 0 ]]; then
    for i in "${MODULES[@]}"
    do
      echo "$i"
    done
  else
    echo "No modules installed"
  fi

  # Also default cog
  printf "\n${WHITE}Commands:${NC} \n"
  # printf "module\n"
  printf "update\n"

  printf "\n--------------------------------------------------------"
  printf "\n${YELLOW}Full README here: ${GRAY}https://github.com/Gearbox-built/cog${NC}"
  printf "\n--------------------------------------------------------\n\n"
}
