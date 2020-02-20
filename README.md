# ⚙️ Cog

Script to automate lots of bash stuff

`Usage: cog <command>`

## • Prerequisites

- bpkg - https://github.com/bpkg/bpkg

## • Installing Cog

```sh
curl -o- -L https://raw.githubusercontent.com/gearbox-built/cog/master/install.sh | bash
```

## • Parameters

*The rest coming...*

### Usage:

`cog <command>`

## • Modules

Example module format.

```sh
#!/bin/bash
#
# Cog WordPress Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 9, 2018
#
WP_MODULE_VERSION="1.0.0"
#
# HISTORY:
#
# * 2016-09-19 - v1.0.0 - First Creation
#
# ##################################################
#
if [[ ! "${#BASH_SOURCE[@]}" -gt 0 ]] || [[ "${BASH_SOURCE[${#BASH_SOURCE[@]}-1]##*/}" != 'cog.sh' ]]; then
  echo 'Module must be executed through cog.'
  return || exit
fi
#
cog::source_lib "${BASH_SOURCE[0]}"
#

# ...

#
# Module main
# --------------------------------------------------

wp::main() {
  wp::requirements
  local module; module=$( basename "$( dirname "${BASH_SOURCE[0]}")")

  case "$1" in
    install)
      wp::wp_install "${@:2}"
      ;;
    setup)
      wp::wp_setup "${@:2}"
      ;;
    -v|--version)
      echo $WP_MODULE_VERSION
      cog::exit
      ;;
    *)
      local lib; lib="${module}::${1}::main"

      if [[ $(type -t "$lib") == 'function' ]]; then
        "$lib" "${@:2}"
        cog::exit
      else
        usage "cog wp" "install,setup"
        cog::exit
      fi
      ;;
  esac
}
```

## 🖥 Setting up Local Development

### 1. Clone git repo
```sh
git clone git@github.com:gearbox-built/cog.git cog-dev
```

### 2. Verify Script
```sh
cd cog-dev
./cog

> 
--------------------------------------------------------
Cog
v1.0.1
--------------------------------------------------------

Usage:
cog <module|command>

Modules:
No modules installed

Commands:
update

--------------------------------------------------------
Full README here: https://github.com/Gearbox-built/cog
--------------------------------------------------------
```

### 3. Setup Modules
Create dependencies directory
```sh
mkdir deps
```
Clone/install modules
```sh
# Install for use only
bpkg install gearbox-built/cog-envs

# Clone for development
git clone git@github.com:gearbox-built/cog-envs.git deps/cog-envs
```
