# Cog Util

Utility module for Cog.

## CLI Usage:

- `cog util salts [--file=<file>]` [[...]](#util::update_salts)
- `cog util key [--length=<int>] [--chars=<chars>]` [[...]](#util::random_key)


## Functions:

- `util::update_salts [--file<file>]` [[...]](#util::update_salts)
- `util::random_key [--length=<int>] [--chars=<chars>]` [[...]](#util::random_key)
- `usage $1 [$2] [$3]` [[...]](#usage)
- `warning [$1]` [[...]](#warning)
- `error [$1]` [[...]](#error)

## Usage:


### `util::update_salts`

##### params:
- `--file`: file to update salts in - *default: `.env`*

##### output:

_No console output. File modification only._

```bash
  > cog util salts
  > util::update_salts

  AUTH_KEY='dZKWsWFKNM~&1QWt27uiVsdZKWsWFKNM~&1QWt27uiVs...'
  SECURE_AUTH_KEY='ifY5VKOEBVrLv_aKOEBVrLv_aKOEBVrLv_aKO...'
  LOGGED_IN_KEY='cI?bOal2VHP7oN&a?l2VHP7oN&a?l2VHP7oN&a?...'
  NONCE_KEY='bITvDMPtjCXET@~ZE&rWLbITvDMPtjCXET@~ZE&rWLd...'
  AUTH_SALT='cPE8IX0O4NAmXTr22&UhPcPE8IX0O4NAmXTr22&UhPa...'
  SECURE_AUTH_SALT='YoZeFr0Zzwx_OGYoZeFr0Zzwx_OGYoZeFr0Z...'
  LOGGED_IN_SALT='r8BLMm57;PAyJb+gr8BLMm57;PAyJb+gr8BLMm...'
  NONCE_SALT='F&qJ73+7K`As`qokCMjHF&qJ73+7K`As`qokCMjHiu...'
```


### `util::random_key`

##### params:
- `--length`: `(int)` length of generated key - *default: `64` or `.config`*
- `--chars`: characters to generate key using - *default: ``a-zA-Z0-9!@&_+?~;`` or `.config`*


##### output:
```bash
  > util::random_key
  ST16!mlY+t7E9Eo+m+pyZRKx7!?7~!ADR&J1oo!F&BsYR5l80!2R@9@yG&DDd7dM

  > util::random_key --chars='a-zA-Z' --length=10
  GaaMdvxFlq
```

```bash
  > cog util key
  pY6&`jUiLir?ZQO?hQr9rYMpvFZBjt7Knk&YQ4eUESgn!Dm&Yl6xKuTw161PB_!E

  > cog util key --chars='GEARBOXCOG' --length=15
  GBBOARGGAXRBCCC
```


### `usage`

##### params:
- `$1`: parent function - eg. `cog util` or `cog server` _**- required**_
- `$2`: child functions (comma delimited) - eg. `salts;random-key` or `db create,db delete`
- `$3`: full doc/man URL - eg. `https://github.com/...`


##### output:
```bash
  > usage "cog util" "salts,random-key,function" "https://github.com/..."


  Usage:
  cog util salts
       or: random-key
       or: function

  Full README here: https://github.com/...
```

```bash
  > usage "cog server" "db create [--name=<name>],db delete [--name=<name>]" "https://github.com/..."


  Usage:
  cog server db create [--name=<name>]
         or: db delete [--name=<name>]

  Full README here: https://github.com/...
```


### `warning`

Displays `Warning` in yellow, followed by the provided message. Continues execution.

##### params:
- `$1`: message to warn with

##### output:
```bash
  > warning "That didn't seem to work, but we're not too concerned."

  Warning: That didn't seem to work, but we're not too concerned.
```


### `error`

Displays `Error` in red, followed by the provided message. Exits immediately.

##### params:
- `$1`: message to error with

##### output:
```bash
  > error "That didn't seem to work. We needed that to work."

  Error: That didn't seem to work. We needed that to work. Exiting.
```
