#!/bin/bash
#
# Gearbox Bitbucket Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 15, 2016
#

# TODO: THIS NEEDS TO BE UPDATED TO THE LATEST BITBUCKET API STANDARD

bitbucket::api() {
  if [[ -z "$BITBUCKET_USER" || -z "$BITBUCKET_API" ]]; then
    error "Please configure your Bitbucket account."
  fi
  if [[ -z "$1" || -z "$2" ]]; then
    usage "cog bitbucket" 'api,<method>,<endpoint>,[<data>]' "param"
  fi

  if [[ -z "$1" ]]; then
    error "No method type provided."
  fi

  if [[ -z "$2" ]]; then
    error "No endpoint provided."
  fi

  local result
  result=$(curl -s --request "$1" \
    --user "${BITBUCKET_USER}":"${BITBUCKET_API}" \
    --url https://api.bitbucket.org/2.0/"$2" \
    --header 'content-type: application/json' \
    --data '{ '"$3"' }')

  if [[ -n "$DEBUG" ]]; then
    echo "$result"
  fi

  if [[ $result == *"error"* ]]; then
    return "$result"
  else
    return 0
  fi
}

bitbucket::check() {
  if [[ -z "$1" ]]; then
    usage 'cog bitbucket list <name>'
    error "No repo name provided."
  fi

  local url; url="repositories/${BITBUCKET_USER}/${1}"
  bitbucket::api "GET" "$url"

  if [[ ! $? -eq 0 ]]; then
    return 1
  else
    return 0
  fi
}

bitbucket::delete() {
  if [[ -z "$1" ]]; then
    usage 'cog bitbucket delete <name>'
    error "No repo name provided."
  fi

  warning_check "This action will delete all the contents in the repo: ${YELLOW}${1}${NC}. This is ${RED}IRREVERSIBLE.${NC}"

  local url; url="repositories/${BITBUCKET_USER}/${1}"
  bitbucket::api "DELETE" "$url"

  if [[ ! $? -eq 0 ]]; then
    warning "Failed to delete repository."
  else
    return 0
  fi
}

bitbucket::create() {
  if [[ -z "$1" ]]; then
    usage 'cog bitbucket create <name>'
    error "No repo name provided."
  fi

  local url; url="repositories/${BITBUCKET_USER}/${1}"
  local data; data='"private": true, "scm": "git", "project": { "key": "'"${BITBUCKET_PROJECT}"'" }'
  bitbucket::api "POST" "$url" "$data"

  if [[ ! $? -eq 0 ]]; then
    error "Error creating repo. Check your config or if the repo exists."
  else
    success "Repo created."
  fi
}

bitbucket::setup() {
  if [[ -z "$1" ]]; then
    usage 'cog bitbucket create <name>'
    error "No repo name provided."
  fi

  bitbucket::create "$@"

  if [[ ! $? -eq 0 ]]; then
    error "Failed to perform Bitbucket setup."
  else
    git init
    git remote add origin "git@bitbucket.org:${BITBUCKET_USER}/${1}.git"
  fi
}

bitbucket::clone() {
  if [[ -z "$1" ]]; then
    usage 'cog bitbucket clone <name>'
    error "No repo name provided."
  fi

  git clone "git@bitbucket.org:${BITBUCKET_USER}/${1}.git"
}


#
# Module main
# --------------------------------------------------

bitbucket::main() {

  case "$1" in
    create)
      bitbucket::create "${@:2}"
      ;;
    delete)
      bitbucket::delete "${@:2}"
      ;;
    setup)
      bitbucket::setup "${@:2}"
      ;;
    check)
      bitbucket::check "${@:2}"
      ;;
    clone)
      bitbucket::clone "${@:2}"
      ;;
    *)
      usage "cog bitbucket" "create,delete,setup,check,clone"
      exit_cog
      ;;
  esac
}