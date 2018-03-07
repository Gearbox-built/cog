#!/bin/bash
#
# Pantheon Code Lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

pantheon::code::pull() {
  echo "Code Pull"

  # 1. Pull Project down via git
  # git clone ssh://codeserver.dev.7c98b46b-fe45-4a8a-8e03-aeaefe9fea5a@codeserver.dev.7c98b46b-fe45-4a8a-8e03-aeaefe9fea5a.drush.in:2222/~/repository.git .
}


#
# Lib main
# --------------------------------------------------

pantheon::code::main() {
  case "$1" in
    pull)
      pantheon::code::pull "${@:2}"
      ;;
    push)
      pantheon::code::push "${@:2}"
      ;;
    *)
      usage "cog pantheon code" "pull,push"
      cog::exit
  esac
}