#!/bin/bash
#
# Cog Bedrock lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: September 19, 2016
#

wp::bedrock_install() {
  for i in "$@"
  do
    case $i in
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  local dir=${dir:-$( pwd )}

  message "Cloning Bedrock..."
  git clone --depth=1 "$BEDROCK_GIT_REPO" "$dir" && rm -rf "${dir}/.git"

  message "Running composer install..."
  composer -d="$dir" update

  if [[ ! $? -eq 0 ]]; then
    error "Failed on Bedrock Install."
  fi
}

wp::bedrock_config() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --url=*)
        local url="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 2 || -z "$name" || -z "$url" ]]; then
    usage "cog wp bedrock" "config, --name=<name>, --url=<url>,[--dir=<dir>]" "args"
    exit_cog
  fi

  local dir; dir=${dir:-$( pwd )}
  local url=${url//\//\\/}

  message "Configing Bedrock..."

  # Need that env doe
  util::require_env "$dir"

  # Bedrock .env file
  perl -pi -e "s/DB_NAME=.*/DB_NAME=${name}/g" "${dir}/.env"
  perl -pi -e "s/DB_USER=.*/DB_USER=root/g" "${dir}/.env"
  perl -pi -e "s/DB_PASSWORD=.*/DB_PASSWORD=root/g" "${dir}/.env"
  perl -pi -e "s/DB_HOST=.*/DB_HOST=localhost/g" "${dir}/.env"
  perl -pi -e "s/WP_HOME=.*/WP_HOME=${url}/g" "${dir}/.env"

  wp::update_salts --file="${dir}/.env"
}

wp::bedrock_setup() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --url=*)
        local url="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 2 || -z "$name" || -z "$url" ]]; then
    usage "cog wp bedrock" "setup, --name=<name>, --url=<url>,[--dir=<dir>]" "args"
    exit_cog
  fi

  local dir; dir=${dir:-$( pwd )}

  wp::bedrock_install "$@"
  wp::bedrock_config "$@"
}

#
# TODO: replace this with a better check for finding .env/project root...
# --------------------------------------------------

check_for_env() {
  for i in "$@"
  do
    case $i in
      --nice)
        local nice=true
        ;;
    esac
  done

  # NO EDGE CASES, JAKE
  if [ -d site ]; then
    cd site || exit
  elif [ -f ../../../../.env ]; then
    cd ../../../../ || exit
  fi

  if [ -f .env ] || [ -f wp-config.php ]; then
    return 0
  else
    if [[ -n "$nice" ]]; then
      return 1
    else
      error "Failed to find .env file!${NC} Please navigate to the location of your project's .env or gulpfile.js file then try again."
    fi
  fi
}


#
# Lib main
# --------------------------------------------------

wp::bedrock::main() {
  case "$1" in
    install)
      wp::bedrock_install "${@:2}"
      ;;
    config)
      wp::bedrock_config "${@:2}"
      ;;
    setup)
      wp::bedrock_setup "${@:2}"
      ;;
    *)
      local func="cog wp bedrock"
      local sub="install [--dir=<dir>]"
      sub="${sub},config --name=<name> --url=<url> [--dir=<dir>]"
      sub="${sub},setup --name=<name> --url=<url> [--dir=<dir>]"
      usage "$func" "$sub"
      exit_cog
  esac
}