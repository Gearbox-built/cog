#!/bin/bash
#
# Pantheon Database Lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

pantheon::db::pull() {
  for i in "$@"
  do
    case $i in
      --env=*)
        local env="${i#*=}"
        ;;
      --site=*)
        local site="${i#*=}"
        ;;
    esac
  done

  if [[ "$#" -lt 1 || -z "$site" ]]; then
    usage "cog pantheon db" "pull, --site=<site>,[--name=<name>],[--env=<env>]" "args"
    cog::exit
  fi

  local env; env=${env:-dev}
  local name; name=${name:-${site}}

  message "Pulling Pantheon dev database..."

  # Create backup and pull
  # terminus backup:create <site>.<env> --element=db -q
  # terminus backup:get <site>.<env> --element=db -q

  # Import backup
  # gunzip < database.sql.gz | mysql -uUSER -pPASSWORD DATABASENAME
}


# developer3@Troys-iMac db $ terminus backup:list my-family-stuff.dev --element=db
#  ------------------------------------------------------------- -------- --------------------- --------------------- -----------
#   Filename                                                      Size     Date                  Expiry                Initiator
#  ------------------------------------------------------------- -------- --------------------- --------------------- -----------
#   my-family-stuff_dev_2017-07-24T00-02-04_UTC_database.sql.gz   17.1MB   2017-07-24 00:02:27   2018-07-24 00:02:27   manual
#  ------------------------------------------------------------- -------- --------------------- --------------------- -----------
#
# # Get the backup
# terminus backup:get my-family-stuff.dev --element=db --to=my-family-stuff_dev_2017-07-24T00-02-04_UTC_database.sql.gz
#
# # Import the backup
# gunzip < my-family-stuff_dev_2017-07-24T00-02-04_UTC_database.sql.gz | mysql -uroot -proot myfamilystuff


#
# Lib main
# --------------------------------------------------

pantheon::db::main() {
  case "$1" in
    pull)
      pantheon::db::pull "${@:2}"
      ;;
    *)
      usage "cog pantheon db" "pull"
      cog::exit
  esac
}