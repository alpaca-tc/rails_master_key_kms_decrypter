
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_master_key_kms_decrypter/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_master_key_kms_decrypter'
  spec.version       = RailsMasterKeyKmsDecrypter::VERSION
  spec.authors       = ['alpaca-tc']
  spec.email         = ['alpaca-tc@alpaca.tc']

  spec.summary       = 'AWS KMS decryption for rails credentials'
  spec.description   = 'AWS KMS decryption for rails credentials'
  spec.homepage      = 'https://github.com/alpaca-tc/rails_master_key_kms_decrypter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-kms'
  spec.add_dependency 'rails', '>= 5.2.0.rc1'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
