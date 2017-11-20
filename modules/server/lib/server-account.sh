#!/bin/bash
#
# Server Account lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 20, 2017
#

server::account_create() {
  for i in "$@"
  do
    case $i in
      --domain=*)
        local domain="${i#*=}"
        ;;
      --user=*)
        local user="${i#*=}"
        ;;
      --email=*)
        local email="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 2 || -z "$user" || -z "$domain" ]]; then
    usage "cog server account" "create,--user=<user>,--domain=<domain>" "arg"
    exit_cog
  fi

  local result
  email=${email:-$ADMIN_EMAIL}
  result=$(server::whm "createacct username=${user} domain=${domain} contactemail=${email}")

  if [[ $result == 0 ]]; then
    success "Created account ${YELLOW}${user}${NC}"
  else
    echo "$result"
  fi
}

server::account_setup() {
  for i in "$@"
  do
    case $i in
      --domain=*)
        local domain="${i#*=}"
        ;;
      --user=*)
        local user="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 2 || -z "$user" || -z "$domain" ]]; then
    usage "cog server account" "setup, --user=<user>, --domain=<domain>,[--name=<db-name>],[--db-user=<db-user>]" "arg"
    exit_cog
  fi

  server::account_create "$@"
  server::db_setup "$@"
}


#
# Lib main
# --------------------------------------------------

server::account::main() {
  case "$1" in
    create)
      server::account_create "${@:2}"
      ;;
    setup)
      server::account_setup "${@:2}"
      ;;
    *)
      usage "cog server account" "create --user=<user> --domain=<domain>,setup --user=<user> --domain=<domain> [--name=<db-name>] [--db-user=<db-user>]"
      exit_cog
  esac
}