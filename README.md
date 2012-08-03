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

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
