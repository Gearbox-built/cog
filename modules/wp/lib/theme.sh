#!/bin/bash
#
# WP Theme lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

wp::theme_download() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --dev=*)
        local dev=true
        ;;
    esac
  done

  local dir=${dir:-${name:-$( pwd )}}

  message "Cloning Gearbox Base Theme..."

  git clone --depth=1 "$WP_THEME_REPO" "$dir"

  if [[ -z $dev ]]; then
    rm -rf "${dir}/.git"
  fi
}

wp::theme_config() {
  for i in "$@"
  do
    case $i in
      --url=*)
        local url="${i#*=}"
        ;;
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

  if [[ "$#" -lt 2 || -z $url ]]; then
    usage "cog wp theme" "config, --url=<url>,--human=<human>|--name=<name>,[--dir=<dir>]" "args"
    return 1
  fi

  local dir=${dir:-$( pwd )}
  local human=${human:-${name}}

  # Theme stuff
  message "Config Gearbox Base Theme..."
  wp::theme_update_manifest "$url" "$dir"

  # Style.css
  perl -pi -e "s/Gearbox Base/${human}/g" "${dir}/style.css"
  perl -pi -e "s/Gearbox Base theme/${human} theme/g" "${dir}/style.css"

  if [ ! $? -eq 0 ]; then
    error "Failed to configure Gearbox Base Theme"
  fi
}

wp::theme_update_manifest() {
  if [[ -z "$1" ]]; then
    error "No project URL provided."
  fi

  local url=${1//\//\\/}
  local theme_dir=${2:-$( pwd )}

  if [[ ! -d "$theme_dir" ]]; then
    warning "Directory not found. Please manually update the manifest.json file..."
    return 1
  fi

  # Manifest
  message "Updating the Manifest..."
  perl -pi -e "s/\"devUrl\":.*/\"devUrl\": \"${url}\"/g" "${theme_dir}/assets/manifest.json"
}

wp::theme_compile() {
  local theme_dir=${1:-$( pwd )}

  if [[ ! -d "$theme_dir" ]]; then
    warning "Directory not found. Please manually install/compile theme assets..."
    return 1
  fi

  cd "$theme_dir" || exit

  # Yarn
  message "Running Yarn install..."
  if [[ -n $DEBUG ]]; then
    yarn install
  else
    yarn install &> /dev/null
  fi

  if [ ! $? -eq 0 ]; then
    warning "Yarn failed!! Continuing..."
  else
    success "Yarn succeeeeeed!"
  fi

  # Bower and Gulp
  message "Running Bower install and Gulp..."
  if [[ -n $DEBUG ]]; then
    bower install && gulp
  else
    bower install &> /dev/null
    gulp &> /dev/null
  fi

  if [ ! $? -eq 0 ]; then
    warning "Bower or gulp failed!! Continuing..."
  else
   success "Bower & Gulp succeeeeeed!"
  fi

  cd - > /dev/null || exit
}

wp::theme_activate() {
  for i in "$@"
  do
    case $i in
      --name=*)
        local name="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 2 || -z $name ]]; then
    usage "cog wp theme" "activate, --name=<name>" "args"
    return 1
  fi

  # Activate
  message "Activating Theme..."
  wp theme activate "$name"

  # Defaults
  if [[ $(type -t "wp::defaults") == 'function' ]]; then
    message "Running Theme defaults..."
    wp::defaults "$@"
  fi
}

wp::theme_install() {
  # check_for_env

  for i in "$@"
  do
    case $i in
      --url=*)
        local url="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
      --dev=*)
        local dev=true
        ;;
      --name=*)
        local name="${i#*=}"
        ;;
      --human=*)
        local human="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 1 || -z $url || -z $name ]]; then
    usage "cog wp theme" "install, --url=<url>, --name=<name>,[--dir=<dir>],[--dev]" "args"
    return 1
  fi

  local dir; dir=${dir:-$name}

  # Remove old themes first
  message "Remove default themes? (y/n)"
  read -r check

  if [[ "$check" == "y" || "$check" == "Y" ]]; then
    # Remove themes
    message "Removing themes..."
    rm -rf twenty*
  fi

  # Do this
  wp::theme_download "$@"

  cd "$dir" || exit
  wp::theme_compile "$dir"
  wp::theme_config "$@"
  wp::theme_activate "$@"
}


#
# Lib main
# --------------------------------------------------

wp::theme::main() {
  case "$1" in
    install)
      wp::theme_install "${@:2}"
      ;;
    download)
      wp::theme_download "${@:2}"
      ;;
    compile)
      wp::theme_compile "${@:2}"
      ;;
    defaults)
      wp::defaults "${@:2}"
      ;;
    *)
      usage "cog wp theme" "install --url=<url> [--dir=<dir>] [--dev],download [--dir=<dir>] [--dev],compile [<dir>]"
      exit_cog
  esac
}