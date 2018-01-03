#!/bin/bash
#
# Cog Shopify Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

shopify::install ()
{

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

  message "Setting up Shopify theme..."
  theme bootstrap --password="$pass" --store="$store" --dir="$dir"

  # We still want this, kay?
  cp -pr config.yml ../config.yml.bak

  # Get rid of everything
  rm -rf ./*

  shopify::clone "$@"

  # Config
  # TODO: figure out how to do this...
  mv ../config.yml.bak config.yml

  # Maybe?
  # cp -pr config-sample.yml config.yml
  # cat ../config.yml.bak 1<> config.yml

  # Set it all up
  shopify::config "$@"
  yarn install && bower install

  # Overwrite the server
  gulp build-push
}

shopify::clone()
{

  for i in "$@"
  do
    case $i in
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  local dir=${dir:-$( pwd )}

  # Get the Shopify Theme
  message "Cloning Shopify Theme..."
  git clone --depth=1 "$SHOPIFY_GIT_REPO" "$dir" && rm -rf .git
}

shopify::config()
{

  for i in "$@"
  do
    case $i in
      --store=*)
        local store="${i#*=}"
        ;;
      --human=*)
        local human="${i#*=}"
        ;;
    esac
  done

  local url=${store//\//\\/}
  message "Configuring Shopify Theme..."

  # Theme
  perl -pi -e "s/\"devUrl\":.*/\"devUrl\": \"${url}\"/g" build/manifest.json
  perl -pi -e "s/{theme_name}/${human}/g" config/settings_schema.json
  perl -pi -e "s/{theme_description}/Shopify Theme for ${human}/g" config/settings_schema.json
}


#
# Module main
# --------------------------------------------------

shopify::main() {

  case "$1" in
    install)
      shopify::install "${@:2}"
      ;;
    clone)
      shopify::clone "${@:2}"
      ;;
    *)
      usage "cog shopify" "install,clone"
      exit_cog
      ;;
  esac
}