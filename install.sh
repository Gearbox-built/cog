#!/bin/bash
# Cogcogcog
# Source: https://github.com/gearbox-built/cog/install.sh
#

set -e

NAME='cog'
REMOTE=${REMOTE:-https://github.com/gearbox-built/cog}

# Terminal colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
GRAY='\033[1;30m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

cog_get_tarball() {
  printf "${BLUE}> Downloading tarball...${NC}\n"
  if [ "$1" = '--version' ]; then
    # Validate that the version matches MAJOR.MINOR.PATCH to avoid garbage-in/garbage-out behavior
    version=$2
    if echo $version | grep -qE "^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$"; then
      url="${REMOTE}/archive/v${version}.tar.gz"
    else
      printf "${RED}> Version number must match MAJOR.MINOR.PATCH.${NC}\n"
      exit 1
    fi
  else
    url="${REMOTE}/archive/master.tar.gz"
  fi
  # Get both the tarball and its GPG signature
  tarball_tmp=$(mktemp -t cog.tar.gz.XXXXXXXXXX)
  if curl --fail -L -o "$tarball_tmp" "$url"; then
    printf "${BLUE}> Extracting to ~/.cog...${NC}\n"
    # All this dance is because `tar --strip=1` does not work everywhere
    temp=$(mktemp -d cog.XXXXXXXXXX)
    tar zxf $tarball_tmp -C "$temp"
    mkdir .cog
    mv "$temp"/*/{*,.[^.]*} .cog
    rm -rf "$temp"
    rm $tarball_tmp*
  else
    printf "${RED}> Failed to download $url.${NC}\n"
    exit 1
  fi
}

cog_detect_profile() {
  if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
    echo "${PROFILE}"
    return
  fi

  local DETECTED_PROFILE
  DETECTED_PROFILE=''
  local SHELLTYPE
  SHELLTYPE="$(basename "/$SHELL")"

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  elif [ "$SHELLTYPE" = "fish" ]; then
    DETECTED_PROFILE="$HOME/.config/fish/config.fish"
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    if [ -f "$HOME/.profile" ]; then
      DETECTED_PROFILE="$HOME/.profile"
    elif [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
      DETECTED_PROFILE="$HOME/.zshrc"
    elif [ -f "$HOME/.config/fish/config.fish" ]; then
      DETECTED_PROFILE="$HOME/.config/fish/config.fish"
    fi
  fi

  if [ ! -z "$DETECTED_PROFILE" ]; then
    echo "$DETECTED_PROFILE"
  fi
}

cog_link() {
  printf "${BLUE}> Adding to \$PATH...${NC}\n"
  COG_PROFILE="$(cog_detect_profile)"
  SOURCE_STR="\nexport PATH=\"\$HOME/.cog:\$PATH\"\n"

  if [ -z "${COG_PROFILE-}" ]; then
    printf "${RED}> Profile not found. Tried ${COG_PROFILE} (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile.\n"
    echo "> Create one of them and run this script again"
    echo "> Create it (touch ${COG_PROFILE}) and run this script again"
    echo "   OR"
    printf "> Append the following lines to the correct file yourself:${NC}\n"
    command printf "${SOURCE_STR}"
  else
    if ! grep -q 'cog' "$COG_PROFILE"; then
      if [[ $COG_PROFILE == *"fish"* ]]; then
        command fish -c 'set -U fish_user_paths $fish_user_paths ~/.cog'
        printf "${BLUE}> We've added ~/.cog to your fish_user_paths universal variable\n"
      else
        command printf "$SOURCE_STR" >>"$COG_PROFILE"
        printf "${BLUE}> We've added the following to your $COG_PROFILE\n"
      fi

      echo "> If this isn't the profile of your current shell then please add the following to your correct profile:"
      printf "   $SOURCE_STR${NC}\n"
    fi

    printf "${GREEN}> Successfully installed Cog! Please open another terminal where the \`cog\` command will now be available.${NC}\n"
  fi
}

cog_reset() {
  unset -f cog_install cog_reset cog_get_tarball cog_link cog_detect_profile
}

cog_install() {
  printf "${WHITE}Installing Cog!${NC}\n"

  if [ -d "$HOME/.cog" ]; then
    if which cog; then
      local latest_url
      local specified_version
      local version_type
      if [ "$1" = '--version' ]; then
        specified_version=$2
        version_type='specified'
      else
        specified_version=$(git ls-remote --tags --refs --sort="v:refname" $REMOTE | tail -n1 | sed 's/.*\///')
        version_type='latest'
      fi
      cog_version=$(cog -V)
      cog_alt_version=$(cog --version)

      if [ "$specified_version" = "$cog_version" -o "$specified_version" = "$cog_alt_version" ]; then
        printf "${GREEN}> Cog is already at the $specified_version version.${NC}\n"
        exit 0
      else
        printf "${YELLOW}> $cog_alt_version is already installed, Specified version: $specified_version.${NC}\n"
        rm -rf "$HOME/.cog"
      fi
    else
      printf "${RED}> $HOME/.cog already exists, possibly from a past Cog install.${NC}\n"
      printf "${RED}> Remove it (rm -rf $HOME/.cog) and run this script again.${NC}\n"
      exit 0
    fi
  fi

  cog_get_tarball $1 $2
  cog_link
  cog_reset
}

cd ~
cog_install $1 $2
