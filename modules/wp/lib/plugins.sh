#!/bin/bash
#
# WP Plugins lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: September 18, 2016
#

wp::plugins_install() {
  for i in "$@"
  do
    case $i in
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  local dir; dir=${dir:-$( pwd )}

  message "Installing Plugins..."
  git_command="git -C $dir"
  $git_command init && $git_command remote add origin "$WP_PLUGIN_REPO" && $git_command fetch && $git_command pull origin master && rm -rf "${dir}/.git"

  wp::plugins_activate
}

wp::plugins_activate() {
  # Activate plugins
  # TODO: move plugins to .plugins
  message "Activating Plugins..."
  wp plugin install $WP_PLUGINS_ACTIVATE
  wp plugin activate $WP_PLUGINS_ACTIVATE
}


#
# Lib main
# --------------------------------------------------

wp::plugins::main() {
  case "$1" in
    install)
      wp::plugins_install "${@:2}"
      ;;
    activate)
      wp::plugins_activate "${@:2}"
      ;;
    *)
      usage "cog wp plugins install" "activate"
      cog::exit
      ;;
  esac
}