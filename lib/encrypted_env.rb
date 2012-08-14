require "encrypted_env/version"
require 'encrypted_env/env'
require 'encryptor'
require 'base64'

ENV.send(:extend, EncryptedEnv::ENV)

module EncryptedEnv
  # The default options used when called encrypt and decrypt
  #
  # Defaults to Encryptor.default_options, or { :algorithm => 'aes-256-cbc' }
  def self.default_options
    @default_options || ::Encryptor.default_options
  end

  # Sets some default options that are globally used
  #
  # Valid keys are
  #  :key -> The encryption key
  #  :algorithm -> run 'openssl list-cipher-commands' to see what can be used
  def self.default_options=(options={})
    @default_options = default_options.merge(options)
  end


  # Encrypts a value and base64 encodes it into the ENV
  def self.encrypt(value,options={})
    encrypted_value = Encryptor.encrypt(self.default_options.merge(options).merge(:value => value.to_s))

    Base64.strict_encode64 encrypted_value.to_s
  end

  # Decrypt a value already stored in the ENV.  The value is assumed be Base64 encoded
  def self.decrypt(key,options={})
    decoded_value = Base64.decode64 env[key]

    Encryptor.decrypt(self.default_options.merge(options).merge(:value => decoded_value))
  end

  # Returns a hash like structure that should be the ENV.  It defaults to ::ENV
  def self.env
    @env || ::ENV
  end

  # Allows the setting of the environment to something other then ::ENV.  Good for testing or if you are serializing
  # to something.  The items passed should behave like a Hash
  def self.env=(env)
    @env = env
  end
end
