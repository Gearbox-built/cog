#!/bin/bash
#
# Pantheon Files Lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

pantheon::files::push() {
  for i in "$@"
  do
    case $i in
      --env=*)
        local env="${i#*=}"
        ;;
      -d|--database=*)
        local db="${i#*=}"
        ;;
      -f|--files=*)
        local env="${i#*=}"
        ;;
      -m|--message=*)
        local message="${i#*=}"
        ;;
    esac
  done

  local env; env=${env:-dev}
  local db; db=${db:-${env}}
  local files; files=${files:-${env}}

  message "Pushing project to Pantheon..."

  # 1. Push
  # kbox push -- --database=dev --files=dev -m "Syncing Dev"
  # kbox push -- --database="$db" --files="$files" -m "$message"

  # export ENV=dev
  # export SITE=8def37b6-2e5e-465a-9e6a-24226414b6e6
  # rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' . --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:files/
}

pantheon::files::pull() {
  for i in "$@"
  do
    case $i in
      --env=*)
        local env="${i#*=}"
        ;;
      --name=*)
        local name="${i#*=}"
        ;;
      --site=*)
        local site="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 1 || -z "$site" ]]; then
    usage "cog pantheon" "pull, --site=<site>,[--name=<name>],[--env=<env>]" "args"
    exit_cog
  fi

  local env; env=${env:-dev}
  local name; name=${name:-${site}}

  message "Pulling files from Pantheon..."

  # export ENV=dev
  # # Usually dev, test, or live
  # export SITE=[YOUR SITE UUID]
  # # Site UUID from dashboard URL: https://dashboard.pantheon.io/sites/<UUID>

  # # To Upload/Import
  # rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./files/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:files/

  # # To Download
  # rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE@appserver.$ENV.$SITE.drush.in:files/ ~/files


  # # -r: Recurse into subdirectories
  # # -l: Check links
  # # -v: Verbose output
  # # -z: Compress during transfer
  # # Other rsync flags may or may not be supported
  # # (-a, -p, -o, -g, -D, etc are not).
}


#
# Lib main
# --------------------------------------------------

pantheon::files::main() {
  case "$1" in
    pull)
      pantheon::files::pull "${@:2}"
      ;;
    push)
      pantheon::files::push "${@:2}"
      ;;
    *)
      usage "cog pantheon files" "pull,push"
      exit_cog
  esac
}