#!/bin/bash
#
# Server DB lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: October 6, 2016
#

server::db_create() {
  for i in "$@"
  do
    case $i in
      --user=*)
        local user="${i#*=}"
        ;;
      --name=*)
        local name="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$user" ]]; then
    usage "cog server db" "create, --user=<user>,[--name=<name>]" "arg"
    exit_cog
  fi

  # Truncate user if db name isn't passed in
  local name=${name:-${user:0:8}_wp}

  local result
  result=$(server::cpanel_mysql "${user}" "create_database name=${name}")

  if [[ $result == 0 ]]; then
    success "Created database ${YELLOW}${name}${NC}"
  else
    echo "$result"
    exit_cog
  fi
}

server::db_create_user() {
  for i in "$@"
  do
    case $i in
      --user=*)
        local user="${i#*=}"
        ;;
      --db-user=*)
        local name="${i#*=}"
        ;;
      --pass=*)
        local pass="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$user" ]]; then
    usage "cog server db" "create-user, --user=<user>,[--db-user=<db-user>],[--pass=<pass>]" "arg"
    exit_cog
  fi

  # Truncate user if db name isn't passed in
  local name=${name:-${user:0:8}_wp}
  local pass=${pass:-$(util::random_key)}

  local result
  result=$(server::cpanel_mysql "${user}" "create_user name=${name} password='${pass}'")

  if [[ $result == 0 ]]; then
    success "Created database user ${YELLOW}${name}${NC}"
    printf "\n--------------------------------------------------------\n"
    printf "${RED}DB User:${NC} %s\n" "${name}"
    printf "${RED}DB Password:${NC} %s" "${pass}"
    printf "\n--------------------------------------------------------\n\n"
  else
    echo "$result"
    printf "\n\n--------------------------------------------------------\n"
    printf "${GRAY}DB User:${NC} %s\n" "${name}"
    printf "${GRAY}DB Password:${NC} %s" "${pass}"
    printf "\n--------------------------------------------------------\n\n"
    exit_cog
  fi
}

server::db_set_privileges() {
  for i in "$@"
  do
    case $i in
      --user=*)
        local user="${i#*=}"
        ;;
      --db-user=*)
        local db_user="${i#*=}"
        ;;
      --name=*)
        local name="${i#*=}"
        ;;
      --privileges=*)
        local privileges="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$user" ]]; then
    usage "cog server db" "set-priviledges, --user=<user>,[--db-user=<db-user>],[--name=<name>],[--privileges=<privileges>]" "arg"
    exit_cog
  fi

  # Truncate user if db name isn't passed in
  local name=${name:-${user:0:8}_wp}
  local db_user=${db_user:-${user:0:8}_wp}
  local privileges=${privileges:-ALL PRIVILEGES}

  local result
  result=$(server::cpanel_mysql "${user}" "set_privileges_on_database user=${db_user} database=${name} privileges=${privileges}")

  if [[ $result == 0 ]]; then
    success "Set database privileges on ${name} for ${db_user} with ${privileges}"
  else
    echo "$result"
    exit_cog
  fi
}

server::db_setup() {
  if [[ $# -lt 1 ]]; then
    usage "cog server db" "setup, --user=<user>,[--name=<db-name>],[--db-user=<db-user>]" "arg"
    exit_cog
  fi

  server::db_create "$@"
  server::db_create_user "$@"
  server::db_set_privileges "$@"
}


#
# Lib main
# --------------------------------------------------

server::db::main() {
  case "$1" in
    create)
      server::db_create "${@:2}"
      ;;
    create-user)
      server::db_create_user "${@:2}"
      ;;
    set-privileges)
      server::db_set_privileges "${@:2}"
      ;;
    setup)
      server::db_setup "${@:2}"
      ;;
    *)
      local func="cog server"
      local sub="db create --user=<user> [--name=<name>]"
      sub="${sub},db create-user --user=<user> [--db-user=<db-user>] [--pass=<pass>]"
      sub="${sub},db set-privileges --user=<user> [--db-user=<db-user>] [--name=<name>] [--privileges=<privileges>]"
      sub="${sub},db setup --user=<user> [--name=<db-name>] [--db-user=<db-user>]"
      usage "$func" "$sub"
      exit_cog
  esac
}