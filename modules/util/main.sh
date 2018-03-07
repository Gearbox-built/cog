#!/bin/bash
#
# Cog Util Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: July 23, 2017
#

util::random_key() {
  if [[ $# -ge 1 ]]; then
    for i in "$@"
    do
      case $i in
        --chars=*)
          local chars="${i#*=}"
          ;;
        --length=*)
          local len="${i#*=}"
          ;;
      esac
    done
  fi

  local chars=${chars:-${SALT_CHARS}}
  local len=${len:-${SALT_LENGTH}}

  cat /dev/urandom | env LC_ALL=C tr -dc "$chars" | fold -w "$len" | head -n 1
}

util::make_dir() {
  if [[ -z "$1" ]]; then
    error "Please provide project directory."
  fi

  if [[ -z "$2" ]]; then
    error "Please provide sub-directory."
  fi

  if [[ -d "$1" ]]
    then
      if [[ -d "${1}/${2}" ]]; then
        printf "\n--------------------------------------------------------"
        printf "\n${RED}Site already exists!${NC} Maybe try another directory?"
        printf "\n--------------------------------------------------------\n"
        cog::exit
      elif [[ "$3" -eq true ]]; then
        cd "$1" && mkdir "$2"
      fi
  else
    mkdir "$1"

    if [[ "$3" -eq true ]]; then
      cd "$1" && mkdir "$2"
    fi
  fi
}

util::new_env() {
  local dir; dir=${1:-$( pwd )}

  cd "$dir" || error "Can't find directory: ${BLUE}${dir}${NC}."

  message "Grabbing an .env file..."

  if [[ -n $DEBUG ]]; then
    curl -O "$BEDROCK_ENV_FILE_DOWNLOAD"
  else
    curl -sO "$BEDROCK_ENV_FILE_DOWNLOAD"
  fi

  if [[ ! $? -eq 0 ]]; then
    warning "Couldn't get the .env file"
  else
    header "Successfully downloaded .env file"
  fi

  cd - > /dev/null || error "Can't find directory."
}

util::config_env() {
  if [[ $# -ge 1 ]]; then
    for i in "$@"
    do
      case $i in
        --ip=*)
          local ip="${i#*=}"
          ;;
        --user=*)
          local user="${i#*=}"
          ;;
        --db=*)
          local db="${i#*=}"
          ;;
        --db-user=*)
          local db_user="${i#*=}"
          ;;
        --db-pass=*)
          local db_pass="${i#*=}"
          ;;
        --url=*)
          local wp_home="${i#*=}"
          ;;
        --file=*)
          local env_file="${i#*=}"
          ;;
      esac
    done
  fi

  if [[ $# -lt 1 ]]; then
    usage "cog util" "config-env, --user=<user>,--db=<db>,--db-user=<db-user>,--db-pass=<db-pass>,--url=<url>,[--ip=<ip>],[--file=<file>]" "arg"
    cog::exit
  fi

  message "Configuring Env file..."
  local ip=${ip:-$SERVER}
  local env_file=${env_file:-.env}

  if [[ -n "$ip" ]]; then
    perl -pi -e "s/PROD_IP=.*/PROD_IP=${ip}/g" "$env_file"
  fi
  if [[ -n "$user" ]]; then
    perl -pi -e "s/PROD_USER=.*/PROD_USER=${user}/g" "$env_file"
  fi
  if [[ -n "$db" ]]; then
    perl -pi -e "s/PROD_DB_NAME=.*/PROD_DB_NAME=${db}/g" "$env_file"
  fi
  if [[ -n "$db_user" ]]; then
    perl -pi -e "s/PROD_DB_USER=.*/PROD_DB_USER=${db_user}/g" "$env_file"
  fi
  # if [[ -n "$db_pass" ]]; then
  #   perl -pi -e "s/PROD_DB_PASS=.*/PROD_DB_PASS='${db_pass}'/g" "$env_file"
  # fi
  if [[ -n "$wp_home" ]]; then
    local url=${wp_home//\//\\/}
    perl -pi -e "s/PROD_WP_HOME=.*/PROD_WP_HOME=${url}/g" "$env_file"
  fi
}

util::require_env() {
  local dir; dir=${1:-$( pwd )}

  # Check for .env file
  if [[ ! -f "${dir}/.env.example" ]]; then
    util::new_env "${dir}"
  fi

  cp "${dir}/.env.example" "${dir}/.env"
}


#
# Module main
# --------------------------------------------------

util::main() {
  case "$1" in
    key)
      util::random_key "${@:2}"
      shift
      ;;
    replace)
      util::random_key "${@:2}"
      shift
      ;;
    new-env)
      util::new_env "${@:2}"
      shift
      ;;
    config-env)
      util::config_env "${@:2}"
      shift
      ;;
    check-requirement)
      cog::check_requirement "${@:2}"
      shift
      ;;
    *)
      local func="cog util"
      local sub="salts [--file=<file>],key [--length=<int>] [--chars=<chars>],new-env [output-path]"
      usage "$func" "$sub"
      cog::exit
  esac
}