# 🔗 cog

Modular shell script to do fun shell things with ease. Cog depends on cog modules to actually do anything. Like [cog-rsync](https://github.com/gearbox-built/cog-rsync) which makes use of [cog-envs](https://github.com/gearbox-built/cog-envs). By itself, cog is a means to making more shell scripting more fun 🎉

## Dependencies

- [curl](http://curl.haxx.se/)
- [coreutils](https://www.gnu.org/software/coreutils/)

### [bpkg](https://github.com/bpkg/bpkg)

- Uses [bpkg](https://github.com/bpkg/bpkg) to easy install cog modules as defined via `package.json`.

## Installing Cog

The easiest way to install cog is by using the cog install script which handles everything so you can do less copying and pasting and more cogging.

```sh
curl -o- -L https://raw.githubusercontent.com/gearbox-built/cog/master/install.sh | bash
```

## Parameters

_The rest coming..._

`cog <command>`

# 🛠 Local Development

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
