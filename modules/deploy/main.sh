#!/bin/bash
#
# Cog Deploy Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#
cog::source_lib "${BASH_SOURCE[0]}"
#

deploy::prep() {
  # Find the env, or bail
  check_for_env
  source .env

  deploy::prep_server
  deploy::prep_config
}


deploy::prep_server() {
  local port; port=${PROD_PORT:-22}

  if [[ "$COPY_SSH_KEY" == true ]]; then
    message "Pushing RSA key to server..."
    cat ~/.ssh/id_rsa.pub | ssh -p "$port" "${PROD_USER}@${PROD_IP}" "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
  fi

  message "Copying .env file to server..."
  cp -pr .env .env.prod
  perl -pi -e "s/WP_ENV=.*/WP_ENV=production/g" .env.prod

  # Copy it up
  scp -P "$port" .env.prod "${PROD_USER}@${PROD_IP}":.env
  rm -rf .env.prod
}


deploy::prep_config() {
  local port; port=${PROD_PORT:-22}
  THEME_NAME=$( ls "$( pwd )/web/app/themes/")
  THEME_DIR="$( pwd )/web/app/themes/${THEME_NAME}"

  message "Checking for syntax..."
  if grep -q "sshPort" "${THEME_DIR}/assets/manifest.json"
    then
      message "Updating manifest.json deploy variables..."
      perl -pi -e "s/\"user\":.*/\"user\": \"${PROD_USER}\",/g" "${THEME_DIR}/assets/manifest.json"
      perl -pi -e "s/\"server\":.*/\"server\": \"${PROD_IP}\",/g" "${THEME_DIR}/assets/manifest.json"
      perl -pi -e "s/\"theme\":.*/\"theme\": \"${THEME_NAME}\",/g" "${THEME_DIR}/assets/manifest.json"
      perl -pi -e "s/\"sshPort\":.*/\"sshPort\": \"${port}\",/g" "${THEME_DIR}/assets/manifest.json"

  elif grep -q "{USERNAME}" "${THEME_DIR}/gulpfile.js"
    then
      warning "${YELLOW}Old Theme: ${NC} Updating gruntfile.js deploy variables...\n"
      perl -pi -e "s/{USERNAME}/${PROD_USER}/g" "${THEME_DIR}/gulpfile.js"
      perl -pi -e "s/{SERVER_IP}/${PROD_IP}/g" "${THEME_DIR}/gulpfile.js"
      perl -pi -e "s/{THEME_FOLDER_NAME}/${THEME_NAME}/g" "${THEME_DIR}/gulpfile.js"
  fi
}


deploy::wp() {
  warning_check "This shit is PRE-ALPHA."

  # Find the env, or bail
  check_for_env
  source .env
  local port; port=${PROD_PORT:-22}

  if [ -f .env ]; then
    cd web/app/themes/* || exit
  fi

  if [ -f gulpfile.js ]; then
    message "Running gulp deploy..."
    gulp deploy
  else
    error "Can't find your gulpfile! Please navigate to the location of your project's .env or gulpfile.js file then try again." ; cog::exit;
  fi

  if [ $? -ne 0 ]; then
    warning_check "Failed to uploaded via gulp!"
  else
    success "Uploaded site to server via gulp."
  fi

  # Deploy the database
  deploy::db

  # Flip dirs
  warning_check "Flip those flipping directories?"
  message "Flipping directories..."
  ssh -p "$port" "${PROD_USER}@${PROD_IP}" "mv public_html/ public_html_old;ln -s web public_html"
}


deploy::db() {
  # Find the env, or bail
  check_for_env
  source .env
  local port; port=${PROD_PORT:-22}

  # Upload DB
  warning_check "Upload database to server database?!"

  # Check if database is empty
  deploy::db_empty

  if [ $? -ne 0 ]; then
    # SUP BB?!
    db::export

    message "Uploading database to server..."
    ssh -p "$port" "${PROD_USER}@${PROD_IP}" mysql --password="${PROD_DB_PASS}" --user="${PROD_DB_USER}" "${PROD_DB_NAME}" < "${DB_EXPORT_DIR}/${DB_EXPORT_NAME}_prod.sql"
  else
    warning_check "Failed to upload database. Database is not empty. Please upload database manually"
  fi

  if [ $? -ne 0 ]; then
    warning_check "Failed to uploaded database to server..."
  else
    success "Uploaded database to server!"
  fi
}

deploy::db_empty() {
  local port; local check; local table;

  # Find the env, or bail
  check_for_env
  source .env

  local table="wp_options"
  port=${PROD_PORT:-22}

  # check=$(ssh -p "$port" "${PROD_USER}@${PROD_IP}" mysql --password="${PROD_DB_PASS}" --user="${PROD_DB_USER}" "${PROD_DB_NAME}" --execute="\"SELECT count(*) FROM ${table};\"" -s)
  check=$(ssh -p "$port" "${PROD_USER}@${PROD_IP}" mysql --password="${PROD_DB_PASS}" --user="${PROD_DB_USER}" "${PROD_DB_NAME}" --execute="\"select * from information_schema.tables;\"" -s | grep "$table")

  if [[ -n "$check" ]]; then
    return 0;
  else
    return 1;
  fi
}


#
# Module main
# --------------------------------------------------

deploy::main() {

  case "$1" in
    prep)
      deploy::prep "${@:2}"
      ;;
    prep-config)
      check_for_env
      source .env
      deploy::prep_config
      ;;
    db)
      deploy::db "${@:2}"
      ;;
    db-check)
      deploy::db_empty "${@:2}"
      ;;
    wp)
      deploy::wp "${@:2}"
      ;;
    *)
      if [[ $(type -t "${1}::lib") == 'function' ]]; then
        "${1}::lib" "${@:2}"
        cog::exit
      else
        usage "cog deploy" "prep,db,wp"
        cog::exit
      fi
      ;;
  esac
}
