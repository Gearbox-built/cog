#!/bin/bash
#
# Server WHM lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: September 18, 2016
#

server::whm() {
  local result
  result=$(${SERVER_SSH_CMD} whmapi1 "${1}")

  # Something went wrong. Give some detail.
  if [[ $result == *"result: 0"* ]]; then

    if [[ $result == *"This system already has an account named"* ]]; then
      echo "Username exists"
    elif [[ $result == *"already exists in the Apache configuration"* ]]; then
      echo "Domain exists"
    else
      echo "$result"
    fi

  # Success
  elif [[ $result == *"result: 1"* ]]; then
    echo 0

  # WTF.
  else
    echo "$result"
  fi
}
