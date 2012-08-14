# EncryptedEnv

Allows you to read from and write to the ENV in an encrypted way.  This is useful if you are running an app on a server
that do you not have complete control over (Heroku).  You can place an encryption key in your code, or in the database.
You can then place your various API tokens in the ENV encrypted.

If you also use attr_encypted to encrypt database columns and store the ENV decryption key in an encrypted column then
a hacker would have to get your code, your database, and your running ENV to get your API keys.  Not 100% fool proof
but a lot more secure.

[![Build Status](https://secure.travis-ci.org/WaterfallFMS/encrypted_env.png)](http://travis-ci.org/WaterfallFMS/encrypted_env)

## Installation

Add this line to your application's Gemfile:

    gem 'encrypted_env', :git => 'git@github.com:WaterfallFMS/encrypted_env.git'

And then execute:

    $ bundle install

## Usage

### Decypting ENV variables (programatically)

If the gem is in your Gemfile then you can just start using it.  Otherwise `require 'encrypted_env'` should be in your
boot script.  Also in the boot script, set the default encryption key
`EncryptedEnv.default_options = {:key => 'default key'}`. If you have a different `:algorithm` you can set that too.

Anywhere you use `ENV['KEY']` change it to `ENV.decrypt('KEY')`.

If you decrypt variables using different keys and algorithms you can pass those in as options to `decrypt`: `Env.decrypt('KEY',:key => 'other encryption key')

Example:

```ruby
# rails config/initializers/asset_sync.rb
require 'encrypted_env'

EncryptedEnv.default_options = {:key => 'super secret', :algorithm => 'aes-256-ecb'}

AssetSync.configure do |config|
  config.fog_provider          = 'AWS'
  config.aws_access_key_id     = ENV.decrypt('AWS_ACCESS_KEY')
  config.aws_secret_access_key = ENV.decrypt('AWS_SECRET_ACCESS_KEY')
  config.fog_directory         = ENV.decrypt('AWS_DIRECTORY')
end
```


### Decrypting ENV Variables (from shell)

`encrypt_env` actually has a decrypt option as well.  It will only read values in the ENV.

```bash
$ encrypted_env decrypt key -k ENCRYPTION_KEY
key: value
```

Full flow might be something like this.

```bash
$ encrypted_env bash KEY=test OTHER=good -k FOOBAR > output.txt ; source output.txt
$ encrypted_env decrypt KEY OTHER -k foobar
# Encryption is case sensitive, hence no output
$ encrypted_env decrypt KEY OTHER -k FOOBAR
KEY: test
OTHER: good
```

### Encrypting ENV Variables

Ruby provides no way to write environment variables, without some serious hacks.  However, it is pretty often that
ENV is used to pass information into a ruby program at start (RAILS_ENV for example).  Often times this will include
API keys so that they do not have been stored in sources or HD.

`encrypt_env` provides output that can be used to print assignment commands that can be used to set up an env with the
 data already encyrpted.

#### Bash

Bash is the default output.

Print something that bash will understand.

```bash
$ ecrypted_env bash var=value var1="value1" etc...
```

Why not just execute set the ENV from it.

```bash
$ encrypt_env bash var=value > output.txt ; source output.txt
```

#### Heroku

Print something that heorku will understand.

```bash
$ ecrypted_env heroku var=value var1="value1" etc...
```

If you already have heroku installed, why not just execute it directly.

```bash
$ `encrypt_env heroku var=value`
```

If you have more then one heroku app for the repo you can specify it with `-r`.

```bash
$ `encrypt_env heroku -r staging var=value`
```

### Custom Algorithms

Run `openssl list-cipher-commands` to view a list of algorithms supported on your platform. See http://github.com/shuber/encryptor for more information.

```
aes-128-cbc
aes-128-ecb
aes-192-cbc
aes-192-ecb
aes-256-cbc
aes-256-ecb
base64
bf
bf-cbc
bf-cfb
bf-ecb
bf-ofb
cast
cast-cbc
cast5-cbc
cast5-cfb
cast5-ecb
cast5-ofb
des
des-cbc
des-cfb
des-ecb
des-ede
des-ede-cbc
des-ede-cfb
des-ede-ofb
des-ede3
des-ede3-cbc
des-ede3-cfb
des-ede3-ofb
des-ofb
des3
desx
idea
idea-cbc
idea-cfb
idea-ecb
idea-ofb
rc2
rc2-40-cbc
rc2-64-cbc
rc2-cbc
rc2-cfb
rc2-ecb
rc2-ofb
rc4
rc4-40
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
