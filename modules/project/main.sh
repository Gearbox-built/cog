#!/bin/bash
#
# Cog Project Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 19, 2017
#

project::push() {
  # Check WP CLI right away
  wp::check_wp_cli

  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      -m|--message=*)
        local message="${i#*=}"
        ;;
      --theme)
        local theme=true
        ;;
    esac
  done

  # Move to that .env file boi
  check_for_env

  if [[ ! -d "../.git" ]]; then
    if [[ "$#" -lt 1 || -z "$name" ]]; then
      usage "cog [project]" "push, --name=<name>,[--dir=<dir>],[-m|--message=<message>]" "args"
      exit_cog
    fi
  fi

  # Fix .gitignore
  if [[ -f .gitignore ]]; then
    perl -pi -e "s/^web\/app\/plugins\/\*/#web\/app\/plugins\/\*/g" .gitignore
    perl -pi -e "s/^web\/app\/uploads\/\*/#web\/app\/uploads\/\*/g" .gitignore
  fi

  # Check for .git
  if [[ -d "web/app/plugins/.git" ]]; then
    rm -rf "web/app/plugins/.git"
  fi
  if [[ -d "web/app/themes/*/.git" ]]; then
    rm -rf "web/app/themes/*/.git"
  fi

  # Let's do this
  cd ../ || exit

  # Setup Bitbucket if not already
  if [[ ! -d .git ]]; then
    message "Creating new Bitbucket repo: $name"
    bitbucket::setup "$name"
    message="Initial commit"
  fi

  if [[ -z $theme ]]; then
    # Export db
    db::export
  fi

  # Add with git
  message "Pushing changes"
  local default_message="Updating"
  message=${message:-$default_message}
  git add -A && git commit -am "$message" && git push origin master
}

project::pull() {
  # Check WP CLI right away
  wp::check_wp_cli

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
      --pull=*)
        local pull="${i#*=}"
        ;;
      --theme)
        local theme=true
        ;;
    esac
  done

  # Move to that .env file boi
  check_for_env --nice

  if [[ ! $? -eq 0 ]]; then
    if [[ "$#" -lt 1 || -z "$name" ]]; then
      usage "cog [project]" "pull, --name=<name>,[--url=<url>],[--dir=<dir>],[--pull=<pull>]" "args"
      exit_cog
    fi
  else
    # Oh. We're just updating?
    project::update
    exit_cog
  fi

  # Variables
  create::variables
  local pull; pull=${pull:-$name}
  local pull_string; pull_string=$(printf "${PULL_STRING}" "$pull")

  # Gogogo...
  message "Pulling: $name from $pull_string"
  git clone "$pull_string" "$path/$name"

  if [[ ! $? -eq 0 ]]; then
    error "Failed to clone repo. Please check that it exists or that you have permission to write to the destination."
  fi

  # Need that env doe
  util::require_env "$site_dir"

  # Bedrock
  composer -d="$site_dir" update
  wp::bedrock_config --name="$name" --url="$url" --dir="$site_dir"

  # DB
  if [[ -z $theme ]]; then
    cd "$site_dir" || exit

    if [[ -d "${root_dir}/db/" ]]; then
      local db_file; db_file=$(ls "${root_dir}"/db/*dev.sql | tail -1) || ''
      db::create_import --file="$db_file"
    else
      warning "No database export available for project. Continuing..."
    fi

    wp rewrite flush --hard
    cd - > /dev/null || exit
  fi

  # WP things
  local theme_dir; theme_dir="$(cd "${site_dir}"/web/app/themes/* && pwd)"
  wp::theme_update_manifest "$url" "$theme_dir"
  wp::theme_compile "$theme_dir"
}

project::update() {
  # Check WP CLI right away
  wp::check_wp_cli

  # Move around
  check_for_env

  if [[ ! -d "../.git" ]]; then
    error "Project pull not setup yet. Run ${YELLOW}cog pull --name=<name>${NC} first."
  fi

  # Pull
  git -C ../ pull origin master

  if [[ ! $? -eq 0 ]]; then
    error "Failed to pull project. No idea why. Go fix it!"
  fi

  if [[ ! -d "../db/" ]]; then
    warning_check "No database exports available for project."
  else
    warning_check "Overwriting local database. ${WHITE}THIS IS ${RED}NOT ${WHITE}A PRANK, BRAH.${NC}"
    local db_file; db_file=$(ls ../db/*dev.sql | tail -1) || ''
    db::import --file="$db_file"
  fi

  # Compile that
  message "Compiling latest changes..."
  cd web/app/themes/* || exit
  gulp
}

#
# Module main
# --------------------------------------------------

project::main() {

  case "$1" in
    push)
      project::push "${@:2}"
      ;;
    pull)
      project::pull "${@:2}"
      ;;
    update)
      project::update "${@:2}"
      ;;
    *)
      usage "cog project" "push,pull,update"
      exit 1
      ;;
  esac
}