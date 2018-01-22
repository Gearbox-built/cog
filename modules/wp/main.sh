#!/bin/bash
#
# Cog WordPress/Roots Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: January 21, 2018
#
WP_MODULE_VERSION="1.0.1"
#
# HISTORY:
#
# * 2018-01-21 - v1.0.1 - Default WP install
# * 2016-09-19 - v1.0.0 - First Creation
#
# ##################################################
#
source_lib "${BASH_SOURCE[0]}"
#

# WordPress Config
# Updates the WordPress configuration.
#
wp::wp_install() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
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
    esac
  done

  local dir; dir=${dir:-$( pwd )}
  local db; db=${db:-$name}
  local db_user; db_user="${db_user:-root}"
  local db_pass; db_pass="${db_pass:-root}"

  cd "$dir" || exit

  message "Installing WP..."
  wp core download
  wp config create --dbname="$name" --dbuser="$db_user" --dbpass="$db_pass"

  cd - > /dev/null || exit
}


# WordPress Config
# Updates the WordPress configuration.
#
wp::config() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --local)
        local local_dev=YES
        ;;
      --file=*)
        local file="${i#*=}"
        ;;
      --output=*)
        local output="${i#*=}"
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
      --db-host=*)
        local db_host="${i#*=}"
        ;;
    esac
  done

  cd "$dir" || exit

  if [[ -n "$local_dev" ]]; then
    if [[ $# -lt 2 ]] || [[ -z "$name" && -z "$db" ]]; then
      local sub="config --local --name=<name>|--db=<db> [--db-user=<db-user>] [--db-pass=<db-pass>] [--db-host=<db-host>]"
      sub="${sub},config --db=<db> --db-user=<db-user> --db-pass=<db-pass> [--db-host=<db-host>]"
      usage "cog wp" "$sub"
      exit_cog
    fi

    local output=${output:-wp-config-local.php}
    local db=${db:-$(printf "$LOCAL_DB" "$name")}
    local db_user=${db_user:-${LOCAL_DB_USER}}
    local db_pass=${db_pass:-${LOCAL_DB_PASS}}
  else
    if [[ $# -lt 4 || -z "$db" || -z "$db_user" || -z "$db_pass" || -z "$db_host" ]]; then
      usage "cog wp" "config, --local, --name=<name>|--db=<db>,[--db-user=<db-user>],[--db-pass=<db-pass>],[--db-host=<db-host>]" "arg"
      usage "cog wp" "config, --db=<db> , --db-user=<db-user>, --db-pass=<db-pass>,[--db-host=<db-host>]" "arg"
      exit_cog
    fi
  fi

  local file=${file:-wp-config-sample.php}
  local output=${output:-wp-config.php}
  local db_host=${db_host:-localhost}

  message "Updating WP Config..."

  #
  if [[ ! -f "$file" ]]; then
    error "Can't find ${YELLOW}$file${NC}."
  fi

  if [[ -f "$output" ]]; then
    warning_check "The file ${YELLOW}${output}${NC} already exists."
  else
    cp -pr "$file" "$output"
  fi

  if [[ -n "$DEBUG" ]]; then
    # Useful output
    printf "\n${GRAY}Name: %s${NC}\n" "$name"
    printf "${GRAY}Local: %s${NC}\n" "$local_dev"
    printf "${GRAY}File: %s${NC}\n" "$file"
    printf "${GRAY}Output: %s${NC}\n" "$output"
    printf "${GRAY}Database: %s${NC}\n" "$db"
    printf "${GRAY}Database User: %s${NC}\n" "$db_user"
    printf "${GRAY}Database Password: %s${NC}\n" "$db_pass"
    printf "${GRAY}Database Host: %s${NC}\n" "$db_host"
  fi
  perl -pi -e "s/(\'DB_NAME\'\,.*)\'.*\'\)/\1'${db}')/" "$output"
  perl -pi -e "s/(\'DB_USER\'\,.*)\'.*\'\)/\1'${db_user}')/" "$output"
  perl -pi -e "s/(\'DB_PASSWORD\'\,.*)\'.*\'\)/\1'${db_pass}')/" "$output"
  perl -pi -e "s/(\'DB_HOST\'\,.*)\'.*\'\)/\1'${db_host}')/" "$output"
  wp::update_salts --file="$output"

  cd - > /dev/null || exit
}

# Update Salts
# Creates new salts and updates the provided or default file
#
# @arg optional --file File that contains salts to be updated (default: wp-config.php)
#
wp::update_salts() {
  if [[ $# -ge 1 ]]; then
    for i in "$@"
    do
      case $i in
        --file=*)
          local salt_file="${i#*=}"
          ;;
      esac
    done
  fi

  local salt; local key
  local salt_file=${salt_file:-wp-config.php}

  message "Generating New Keys/Salts..."

  if [[ -f "$salt_file" ]]; then
    for salt in $WP_SALTS; do
      key=$(util::random_key)
      perl -pi -e "s/${salt}=.*/${salt}='${key}'/g" "$salt_file" # dotenv
      perl -pi -e "s/(\'${salt}\'\,.*)(\'.*\')\)/\1'${key}')/g" "$salt_file"
    done
  else
    error "Cannot find file '$salt_file'."
  fi
}

# Check WP CLI
# Checks that WP CLI is up to date
#
# @arg optional --file File that contains salts to be updated (default: wp-config.php)
#
wp::check_wp_cli() {
  # WP CLI at latest?
  WP_CLI="$(wp cli check-update --format=count)"

  if [[ -n $WP_CLI ]]; then
    warning "WP CLI is ${RED}out of date${NC}. We recommend you update WP CLI before continuing - things often break when not on the latest version"

    echo "Press any key to continue."
    read -n1 -sr
  fi
}

wp::gearboxify() {
  message "Gearboxify."

  # 1. Install theme
  # 2. Install defaults
  # 3. Install plugins
}


#
# Module main
# --------------------------------------------------

wp::main() {
  # TODO: Update .env PROD_USER, PROD_WP_HOME PROD_DB_NAME, PROD_DB_USER, PROD_DB_PASS
  wp::requirements
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    config)
      wp::config "${@:2}"
      ;;
    salt|salts)
      wp::update_salts "${@:2}"
      ;;
    -v|--version)
      echo $WP_MODULE_VERSION
      exit_cog
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        exit_cog
      else
        usage "cog wp" "theme,bedrock,plugins"
        exit_cog
      fi
      ;;
  esac
}