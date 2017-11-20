#!/bin/bash
#
# Cog Usage
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

# Usage
#
cog_usage() {
  printf "\n--------------------------------------------------------\n"
  printf "${BLUE}Cog${NC} ${GRAY}\nv%s${NC}" "$VERSION"
  printf "\n--------------------------------------------------------\n\n"
  printf "${WHITE}Usage:${NC} \n"
  printf "${NAME} <command>\n"
  printf "\n${WHITE}Commands:${NC} \n"
  printf "create\n"
  printf "server\n"
  printf "bitbucket\n"
  printf "deploy\n"
  printf "util\n"
  printf "update\n"
  printf "db\n"
  printf "pantheon\n"
  printf "\n${GREEN}You probably want one of these:${NC}\n"
  printf "\n${WHITE}WP:${NC} \n"
  printf "${NAME} create wp --name=project-name --human='Project Name' --port=7777\n"
  printf "${NAME} create wp --name=project-name\n"
  printf "\n${WHITE}Deploy:${NC} \n"
  printf "${NAME} deploy prep\n"
  printf "${NAME} deploy wp\n"
  printf "\n${WHITE}Server:${NC} \n"
  printf "${NAME} server account setup --user=username --domain=example.com\n"
  printf "${NAME} server ssh    ${GRAY}# server root SSH${NC}\n"
  printf "${NAME} server login  ${GRAY}# server project SSH${NC}\n"
  printf "\n${WHITE}Other:${NC} \n"
  printf "${NAME} create static --name=project-name\n"
  printf "${NAME} create shopify --name=project-name --api=12345asdf1234qwer0987poiu --pass=poiu9087qwer1234asdfg12345 --store=project-name.myshopify.com \n"
  printf "${NAME} update \n"
  printf "\n--------------------------------------------------------"
  printf "\n${YELLOW}Full README here: ${GRAY}https://github.com/Gearbox-built/cog${NC}"
  printf "\n--------------------------------------------------------\n\n"
}