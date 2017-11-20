#!/bin/bash
#
# Server cPanel lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: September 18, 2016
#

server::cpanel() {
  local result
  result=$(${SERVER_SSH_CMD} uapi "${1}")

  if [[ $result == *"status: 0"* ]]; then
    echo "$result"
  elif [[ $result == *"status: 1"* ]]; then
    echo 0
  else
    echo "$result"
  fi
}

server::cpanel_mysql() {
  if [[ $# -lt 2 ]]; then
    echo 'DO IT RIGHT.'; exit_cog
  fi

  server::cpanel "--user=${1} Mysql ${2}"
}
