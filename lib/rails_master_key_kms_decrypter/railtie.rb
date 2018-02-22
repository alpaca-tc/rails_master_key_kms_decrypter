# frozen_string_literal: true

require 'rails'

module RailsMasterKeyKmsDecrypter
  module WithKmsEncryptedConfiguration
    def encrypted(path, key_path: 'config/master.key', env_key: 'RAILS_MASTER_KEY')
      RailsMasterKeyKmsDecrypter::KmsEncryptedConfiguration.new(
        config_path: Rails.root.join(path),
        key_path: Rails.root.join(key_path),
        env_key: env_key,
        raise_if_missing_key: config.require_master_key
      )
    end
  end

  class Railtie < ::Rails::Railtie
    ::Rails::Application.prepend(WithKmsEncryptedConfiguration)
  end
end
