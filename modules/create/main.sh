#!/bin/bash
#
# Cog Create Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: August 24, 2017
#
CREATE_MODULE_VERSION="1.02"
#
# HISTORY:
#
# * 2017-08-28 - v1.0.2 - Bedrock flag actually works now
# * 2017-08-04 - v1.0.1 - Default WP by default, Bedrock optional
# * 2016-09-19 - v1.0.0 - First Creation
#
# ##################################################


# Create WP
# Creates a new WP project
#
# @arg --name       Name of the project
# @arg [--human]    Human readable project name     (default: --name)
# @arg [--dir]      Sub-directory to create project (default: site)
# @arg [--url]      URL for the project             (default: DEFAULT_URL in .config)
# @arg [--email]    Admin email                     (default: ADMIN_EMAIL in .config)
# @arg [--dev]      Keep .git references?           (default: false)
# @arg [--bedrock]  Run Bedrock setup?              (default: false)
# @arg [--pantheon] Pantheon optimized?             (default: true)
#
create::wp() {
  # Check WP CLI right away
  wp::check_wp_cli
  local dev; local pantheon; pantheon=true

  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --human=*)
        local human="${i#*=}"
        ;;
      --port=*)
        local port="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --url=*)
        local url="${i#*=}"
        ;;
      --dev=*)
        local dev=true
        ;;
      --email=*)
        local email="${i#*=}"
        ;;
      --bedrock)
        local bedrock=true
        local pantheon=false
        ;;
      --pantheon)
        # local pantheon=true
        local pantheon=false
        local bedrock=false
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$name" ]]; then
    usage "cog create" "wp, --name=<name>,[--human=<human>],[--port=<port>],[--dir=<dir>],[--url=<url>],[--email=<email>],[--dev],[--bedrock],[--pantheon]" "arg"
    exit_cog
  fi

  # Variables
  create::variables --wp
  email=${email:-$ADMIN_EMAIL}
  local human; human=${human:-$name}
  local admin_user; admin_user=$(printf "$DEFAULT_ADMIN" "$name")
  local admin_pass; admin_pass=$(util::random_key)
  local install_url; install_url=$url

  # Gogogo...
  header "Creating Project:" "$human"

  # Useful output
  printf "\n${GRAY}Project Name: %s${NC}\n" "$name"
  printf "${GRAY}Human Name: %s${NC}\n" "$human"
  printf "${GRAY}Project Directory: %s${NC}\n" "$dir"
  printf "${GRAY}Project URL: %s${NC}\n" "$url"
  printf "${GRAY}Admin Email: %s${NC}\n" "$email"
  printf "${GRAY}Admin User: %s${NC}\n" "$admin_user"
  printf "${GRAY}Admin Pass: %s${NC}\n" "$admin_pass"
  printf "${GRAY}Root Directory: %s${NC}\n" "$path"
  printf "${GRAY}Install Directory: %s${NC}\n" "$site_dir"
  printf "${GRAY}Plugin Directory: %s${NC}\n" "$plugin_dir"
  printf "${GRAY}Theme Directory: %s${NC}\n" "$theme_dir"

  # Make directory
  util::make_dir "$name" "$dir"

  # Bedrock? Or default?
  if [[ -n "$bedrock" ]]; then
    # Setup Bedrock
    wp::bedrock_setup --dir="$site_dir" --name="$name" --url="$url"
    install_url="${install_url}/wp/"
  elif [[ -n "$pantheon" ]]; then
    pantheon::wp_install --dir="$site_dir" --name="$name" --url="$url"
  else
    wp::wp_install "$@"
  fi

  cd "$site_dir" || exit

  # Create database
  db::create

  # Install WordPress
  message "Activating WP..."
  wp core install --url="$install_url" --title="$human" --admin_user="$admin_user" --admin_password="$admin_pass" --admin_email="${email}"
  wp::theme_install --url="$url" --dir="$theme_dir" --name="$name" --human="$human" --dev="$dev"
  wp::plugins_install --dir="$plugin_dir"

  cd - > /dev/null || exit

  if [[ ! $? -eq 0 ]]; then
    error "Finished with errors" false
  else
    success "WP Project created!"
    printf "\n--------------------------------------------------------"
    printf "\n${GREEN}%s${NC} %s" "Project URL:" "$url"
    printf "\n${RED}%s${NC} %s" "Admin User:" "$admin_user"
    printf "\n${RED}%s${NC} %s" "Admin Pass:" "$admin_pass"
    printf "\n--------------------------------------------------------\n"
  fi
}

create::static() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --human=*)
        local human="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$name" ]]; then
    usage "cog create" "static, --name=<name>,[--human=<human>],[--dir=<dir>]" "arg"
    exit_cog
  fi

  # Variables
  dir=${dir:-${DEFAULT_LANDING_DIR}}
  local human; human=${human:-$name}
  create::variables

  header "Creating Static Project:" "$human"

  # Make directory
  util::make_dir "$name" "$dir"
  static::download --dir="$site_dir"
  cd "$site_dir" || exit

  # Static stuff
  static::install --dir="$site_dir"
  static::config --dir="$site_dir" --human="$human"

  if [[ ! $? -eq 0 ]]; then
    error "Finished with errors" false
  else
    success "Static Project created!"
  fi
}

create::shopify() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --human=*)
        local human="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --pass=*)
        local pass="${i#*=}"
        ;;
      --store=*)
        local store="${i#*=}"
        ;;
    esac
  done

  if [[ $# -lt 1 || -z "$name" || -z "$pass" || -z "$store" ]]; then
    usage "cog create" "shopify, --name=<name>, --pass=<pass>, --store=<store>,[--human=<human>],[--dir=<dir>]" "arg"
    exit_cog
  fi

  # Variables
  dir=${dir:-${DEFAULT_SHOPIFY_DIR}}
  local human; human=${human:-$name}
  create::variables

  warning_check "This shit is PRE-ALPHA."
  header "Creating Shopify Project:" "$human"

  # Useful output
  printf "\n${GRAY}Project Name: %s${NC}\n" "$name"
  printf "${GRAY}Project Directory: %s${NC}\n" "$dir"
  printf "${GRAY}Root Directory: %s${NC}\n" "$path"
  printf "${GRAY}Install Directory: %s${NC}\n" "$site_dir"
  printf "${GRAY}Store URL: %s${NC}\n" "$store"
  printf "${GRAY}Store Pass: %s${NC}\n" "$pass"

  # Do things
  util::make_dir "$name" "$dir" true
  cd "$site_dir" || exit
  shopify::install "$@" --dir="$site_dir"

  if [ ! $? -eq 0 ]; then
    error "Finished with errors" false
  else
    success "Shopify Project created!"
  fi
}

create::variables() {
  for i in "$@"
  do
    case $i in
      --wp)
        local wp=true
        ;;
      --bedrock)
        local bedrock=true
        ;;
    esac
  done

  path="$( pwd )"
  dir=${dir:-${DEFAULT_DIR}}
  root_dir="$path/$name"
  site_dir="${root_dir}/$dir"

  if [[ -n "$wp" ]]; then
    port=${port:-${DEFAULT_PORT}}
    url=${url:-$(printf "$DEFAULT_URL" "$name" "$port")}

    if [[ -n "$bedrock" ]]; then
      theme_dir="${site_dir}/web/app/themes/${name}"
      plugin_dir="${site_dir}/web/app/plugins"
    else
      theme_dir="${site_dir}/wp-content/themes/${name}"
      plugin_dir="${site_dir}/wp-content/plugins/"
    fi
  fi
}


#
# Module main
# --------------------------------------------------

create::main() {

  case "$1" in
    wp)
      create::wp "${@:2}"
      ;;
    static)
      create::static "${@:2}"
      ;;
    shopify)
      create::shopify "${@:2}"
      ;;
    -v|--version)
      echo $CREATE_MODULE_VERSION
      exit_cog
      ;;
    *)
      if [[ -n "$2" ]]; then
        create::wp "${@:2}"
      else
        local sub="wp --name=<name> [--human=<human>] [--port=<port>] [--dir=<dir>]"
        sub="${sub},static --name=<name> [--human=<human>] [--port=<port>] [--dir=<dir>]"
        sub="${sub},shopify --name=<name> --api=<api> --pass=<pass> --store=<store>"
        usage "cog create" "$sub"

        # printf "${GRAY}The wp param is actually optional.${NC}\n\n"
        exit_cog
      fi
      ;;
  esac
}