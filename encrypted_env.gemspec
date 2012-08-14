# -*- encoding: utf-8 -*-
require File.expand_path('../lib/encrypted_env/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Kamenik"]
  gem.email         = ["john@waterfallfms.com"]
  gem.description   = %q{Allows for reading and writing to the ENV in an encrypted way}
  gem.summary       = %q{Allows for reading and writing to the ENV in an encrypted way}
  gem.homepage      = "https://github.com/WaterfallFMS/encrypted_env"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "encrypted_env"
  gem.require_paths = ["lib"]
  gem.version       = EncryptedEnv::VERSION

  gem.add_dependency "encryptor"
  gem.add_dependency 'thor'
  gem.add_development_dependency "rspec", "~> 2.0"
end
