#!/bin/bash
#
# Cog Server Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: September 18, 2016
#
cog::source_lib "${BASH_SOURCE[0]}"
#

server::login() {
  if [[ -n $1 ]]; then
    ssh -p "$SERVER_PORT" "${1}@${SERVER}"
  else
    $SERVER_SSH_CMD # ssh command
  fi
}

server::login_project() {
  # Find the env, or bail
  check_for_env
  source .env

  local port; port=${PROD_PORT:-22}
  ssh -p "$port" "${PROD_USER}@${PROD_IP}"
}


#
# Module main
# --------------------------------------------------

server::main() {
  # TODO: Update .env PROD_USER, PROD_WP_HOME PROD_DB_NAME, PROD_DB_USER, PROD_DB_PASS
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    ssh)
      server::login "${@:2}"
      ;;
    login)
      server::login_project "${@:2}"
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        cog::exit
      else
        usage "cog server" "login,ssh,account,db"
        cog::exit
      fi
      ;;
  esac
}