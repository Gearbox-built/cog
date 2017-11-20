#!/bin/bash
#
# Cog Updates
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#
# HISTORY:
#
# * 2017-11-19 - First Creation
#
# ##################################################
#

# Check for Updates
#
check_for_updates() {
  printf "\n${BLUE}Checking for updates...${NC}\n"

  local git_command; local branch
  git_command="git -C $SCRIPT_PATH"
  branch=$($git_command branch | sed -n '/\* /s///p')

  # Set upstream if not already
  if [[ -z "$( $git_command config --get "branch.${branch}.remote")" || -z "$( $git_command config --get "branch.${branch}.merge")" ]]; then
    $git_command branch --set-upstream-to="origin/${branch}" "$branch"
  fi

  # Update refs
  $git_command fetch --all --quiet

  # Grab the useful stuff
  local git_local; local git_remote; local git_base
  git_local="$($git_command rev-parse @)"
  git_remote="$($git_command rev-parse '@{u}')"
  git_base="$($git_command merge-base @ '@{u}')"

  if [[ -n $DEBUG ]]; then
    printf "\n\n${YELLOW}--------------------------------------------------------\n"
    printf "Check for updates"
    printf "\n${YELLOW}--------------------------------------------------------${NC}\n\n"
    printf "LOCAL: %s\n" "$git_local"
    printf "REMOTE: %s\n" "$git_remote"
    printf "BASE: %s\n" "$git_base"
    printf "\n${YELLOW}--------------------------------------------------------${NC}\n"
  fi

  if [ $? -ne 0 ]; then
    printf "\n${YELLOW}Checking for updates failed${NC}. Not sure why but we're continuing anyway. Please make sure your running the latest script.\n"
    return;
  fi

  if [ "$git_local" = "$git_remote" ]; then
    printf "\nHarro.\n\n"
  elif [ "$git_local" = "$git_base" ]; then
    local message; message="Script out of date. Run cog --update for the latest."
    if [[ -n $REQUIRE_UPDATE ]]; then
      error "$message"
    else
      warning "$message"
    fi
  elif [ "$git_remote" = "$git_base" ]; then
    local message; message="Script ahead of origin. Push your changes please."
    if [[ -n $UPDATE ]]; then
      error "$message"
    else
      warning "$message"
    fi
  else
    warning "Script out of date. Or something. Not sure. Maybe push or pull...?"
  fi
}

# Update Self
#
update_self() {
  git_command="git -C $SCRIPT_PATH"

  if [[ $($git_command diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"; then
    error "Git branch is dirty. Commit and push your changes please"
  fi

  printf "\n${GREEN}Getting the latest Cog...${NC}\n"

  $git_command fetch --all && git -C "$SCRIPT_PATH" reset --hard origin/master

  printf "\n--------------------------------------------------------\n"
  if [ $? -ne 0 ]; then
    printf "${RED}Failed to update script.${NC} Make sure RVM is up-to-date - run 'rvm get head' and try again."
  else
    printf "Now using the ${GREEN}latest${NC} Cog!."
  fi
  printf "\n--------------------------------------------------------\n"
}