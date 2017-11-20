#!/bin/bash
#
# Cog Static Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: October 17, 2016
#

static::download() {

  for i in "$@"
  do
    case $i in
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  message "Cloning Static Site project"
  git clone --depth=1 "$JEKYLL_GIT_REPO" "$dir" && cd "$dir" && rm -rf .git

  if [ ! $? -eq 0 ]; then
    error "Failed on Cloning Static Project!"
  fi
}

static::install() {

  for i in "$@"
  do
    case $i in
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  cd "$dir" || exit

  message "Installing static site requirements"

  message "Running Bundler"
  bundle install

  message "Running Yarn install"
  yarn install &> /dev/null

  message "Running Bower install"
  bower install

  cd - > /dev/null || exit
}

static::config() {

  for i in "$@"
  do
    case $i in
      --human=*)
        local human="${i#*=}"
        ;;
      --dir=*)
        local dir="${i#*=}"
        ;;
    esac
  done

  message "Configuring Jekyll"

  # Jekyll _config.yml file
  perl -pi -e "s/^name:(.*)/name: ${human}/g" "$dir/_config.yml"
}
