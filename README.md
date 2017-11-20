# Cog

Script to automate lots of stuff

`Usage: cog <command>`

## Prerequisites

### 1. Install/Update requirements

- npm  - `npm install -g npm`
- bower - `npm install -g bower`
- composer - `brew install composer`
- rvm - `rvm get head`
- wp-cli - see: [https://wp-cli.org/](http://wp-cli.org/#installing)

### 2. Use MAMP libs:

For WP-CLI to work with MAMP, you have to make sure your PHP and MySQL are pointing to the MAMP libs. [See here for instructions](http://stackoverflow.com/questions/4145667/how-to-override-the-path-of-php-to-use-the-mamp-path/29990624#29990624).

### 3. Setup bash alias

Run the following to setup your `cog` alias:

```sh
echo "alias cog='bash ~/scripts/gearbox-cog/cog.sh'" >> ~/.bash_profile && source ~/.bash_profile
```

## Parameters

*The rest coming soon...*

### Usage:

`cog <command>`

#### Commands:
- `create`
- `server`
- `bitbucket`
- `deploy`
- `util`
- `update`
- `db`

#### You probably want one of these:

##### WP:
- `cog create wp --name=project-name --human='Project Name' --port=7777`
- `cog create wp --name=project-name`

##### Deploy:
- `cog deploy prep`
- `cog deploy wp`

##### Server:
- `cog server account setup --user=username --domain=example.com`
- `cog server ssh    # server root SSH`
- `cog server login  # server project SSH`

##### Other:
- `cog create static --name=project-name`
- `cog create shopify --name=project-name --api=12345asdf1234qwer0987poiu --pass=poiu9087qwer1234asdfg12345 --store=project-name.myshopify.com`
- `cog update`
