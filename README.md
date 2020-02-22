# ⚙️ Cog

Script to automate lots of bash stuff

`Usage: cog <command>`

## ⚙︎ Prerequisites

- bpkg - https://github.com/bpkg/bpkg

## ⚙︎ Installing Cog

```sh
curl -o- -L https://raw.githubusercontent.com/gearbox-built/cog/master/install.sh | bash
```

## ⚙︎ Parameters

*The rest coming...*

### Usage:

`cog <command>`

## 🖥 Setting up Local Development

### 1. Clone git repo
```sh
git clone git@github.com:gearbox-built/cog.git cog-dev
```

### 2. Verify Script
```console
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
