#!/bin/bash
#
# Cog Pantheon Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#
PANTHEON_MODULE_VERSION="1.01"
#
# HISTORY:
#
# * 2017-08-04 - v1.0.1 - Pantheon WP Install
# * 2017-07-21 - v1.0.0 - First Creation
#
# ##################################################
#
source_lib "${BASH_SOURCE[0]}"
#

# WordPress Install
# Installs the Pantheon optimized version of WordPress.
#
pantheon::wp_install() {
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
    usage "cog pantheon" "wp-install, --name=<name>, --url=<url>,[--dir=<dir>]" "args"
    exit_cog
  fi

  local dir; dir=${dir:-$( pwd )}

  if [[ -n "$DEBUG" ]]; then
    # Useful output
    printf "\n${GRAY}Name: %s${NC}\n" "$name"
    printf "${GRAY}DIR: %s${NC}\n" "$dir"
    printf "${GRAY}URL: %s${NC}\n" "$url"
    printf "${GRAY}Upstream: %s${NC}\n" "$PANTHEON_WP_UPSTREAM"
  fi

  message "Installing WP for Pantheon..."
  git clone "$PANTHEON_WP_UPSTREAM" "$dir"

  wp::config "$@" --local
  wp::config "$@" --local --output=wp-config.php

  # Comment out the wp-settings.php include in local
  perl -pi -e "s/(require_once.*)/\/\/ \1/" "$dir/wp-config-local.php"
}

# Pantheon Create
# Creates a new Pantheon project
#
# @arg
# @arg
#
pantheon::create() {
  message "Create new Pantheon site..."

  # 1. Create site in Pantheon
  #    terminus site:create --org="$PANTHEON_ORG" gearbox-theme 'Gearbox Theme Development' WordPress
  #    upstream can also be e8fe8550-1ab9-4964-8838-2b9abdccf4bf

  # 2. Install WP Migrate DB
  #    terminus remote:wp gearbox.dev -- plugin activate wp-migrate-db
  #    terminus env:commit gearbox.dev

  # 3. Change to Git from SFTP
  #    terminus connection:set gearbox.dev git

  # sftp -o Port=2222 dev.fcff11b4-b328-47e2-83bf-18fc184ee029@appserver.dev.fcff11b4-b328-47e2-83bf-18fc184ee029.drush.in
  # rsync --port=2222 -avze ssh dev.fcff11b4-b328-47e2-83bf-18fc184ee029@appserver.dev.fcff11b4-b328-47e2-83bf-18fc184ee029.drush.in:/files/ ./*

  pantheon::pull "${@:2}"
}

pantheon::push() {
  echo "Push"
  # Pushing files or db?
}

pantheon::pull() {
  echo "Pull"
  # 1. Pulling files or db?
  # 2. Pulling new project?
  #     - Pull files
  #     - Pull database
  #     - Create wp-config-local.php
}

pantheon::wp-config() {
  echo "WP Config"
  # define('WP_HOME', 'http://site.gearbox.localhost:8888');
  # define('WP_SITEURL', 'http://site.gearbox.localhost:8888');
  # define('WP_ENV', 'development');
  # define('DIST_DIR', '/assets/');
  # define( 'WP_MEMORY_LIMIT', '256M' );
}

#
# Module main
# --------------------------------------------------

# 1. Create new site on Pantheon site:

pantheon::main() {
  pantheon::requirements
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    wp-install)
      pantheon::wp_install "${@:2}"
      ;;
    create)
      pantheon::create "${@:2}"
      ;;
    push)
      pantheon::push "${@:2}"
      ;;
    pull)
      pantheon::pull "${@:2}"
      ;;
    -v|--version)
      echo $PANTHEON_MODULE_VERSION
      exit_cog
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        exit_cog
      else
        usage "cog pantheon" "create,push,pull,db,files"
        exit 1
      fi
      ;;
  esac
}