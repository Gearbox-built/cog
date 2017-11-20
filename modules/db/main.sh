#!/bin/bash
#
# Cog Database Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: January 23, 2017
#

db::create() {
  for i in "$@"
  do
    case $i in
      --dir=*)
        local wp_dir="${i#*=}"
        ;;
    esac
  done

  message "Creating database..."

  if [[ -n "$wp_dir" ]]; then
    wp --path="$wp_dir" db create
  else
    wp db create
  fi

  if [ $? -ne 0 ]; then
    warning_check "Failed to create database. Chances are that the database exists. This operation could overwrite the existing database"
  fi
}

db::export() {
  # Find the env, or bail
  check_for_env
  source .env

  # Variables
  # TODO: Extract these
  DB_EXPORT_DIR=$( pwd )/../db
  DB_EXPORT_NAME=${DB_NAME}_deploy_export_${DB_TS}
  DB_EXPORT_PROD=${DB_EXPORT_DIR}/${DB_EXPORT_NAME}_prod
  DB_EXPORT_DEV=${DB_EXPORT_DIR}/${DB_EXPORT_NAME}_dev

  # Check that the DB directory exists
  if [ ! -d "$DB_EXPORT_DIR" ]; then
    mkdir "$DB_EXPORT_DIR"
  fi

  printf "\n${BLUE}Exporting database...${NC}\n"
  wp migratedb export "$DB_EXPORT_PROD" --find="$WP_HOME" --replace="$PROD_WP_HOME"
  wp migratedb export "$DB_EXPORT_DEV"

  # WAT?! WHY?!
  if [ $? -ne 0 ]; then
    warning_check "Failed to export database. Chances are that the WP Migrate DB is not installed or activated. ${GREEN}Install?${NC} \n"

    message "Installing/activating WP Migrate DB..."
    wp plugin install wp-migrate-db --activate

    if [ $? -ne 0 ]; then
      error "Failed to install or activate WP Migrate DB..."
    else
      success "WP Migrate DB installed and activated."
      db::export
    fi
  fi
}

db::import() {
  for i in "$@"
  do
    case $i in
      --dir=*)
        local wp_dir="${i#*=}"
        ;;
      --file=*)
        local file="${i#*=}"
        ;;
    esac
  done

  if [[ -f "$file" ]]; then
    message "Importing database..."

    if [[ -n "$wp_dir" ]]; then
      wp --path="$wp_dir" db import "$file"
    else
      wp db import "$file"
    fi

    if [ $? -ne 0 ]; then
      warning "Failed to import database..."
    fi
  else
    warning "Failed to import database. Import file missing."
  fi
}

db::import_latest() {
  check_for_env --nice

  if [[ ! $? -eq 0 ]]; then
    local db_file; db_file=$(ls *dev.sql | tail -1) || ''
    db::import --file="$db_file"
  else
    local db_file; db_file=$(ls ../db/*dev.sql | tail -1) || ''
    db::import --file="$db_file"
  fi
}

db::create_import() {
  db::create "$@"
  db::import "$@"
}


#
# Module main
# --------------------------------------------------

# TODO: Create import latest

db::main() {

  case "$1" in
    create)
      db::create "${@:2}"
      ;;
    export)
      db::export "${@:2}"
      ;;
    import)
      db::import "${@:2}"
      ;;
    import-latest)
      db::import_latest "${@:2}"
      ;;
    create-import)
      db::create-import "${@:2}"
      ;;
    *)
      usage "cog db" "create,export,import,import-latest,create-import"
      exit 1
      ;;
  esac
}