# frozen_string_literal: true

module RailsMasterKeyKmsDecrypter
  class KmsEncryptedConfiguration < ActiveSupport::EncryptedConfiguration
    attr_reader :encrypted_env_key, :encrypted_key_path

    # def initialize(config_path:, key_path:, env_key:, raise_if_missing_key:)
    def initialize(*)
      super

      @encrypted_env_key = "ENCRYPTED_#{env_key}"
      @encrypted_key_path = "#{key_path}.enc"
    end

    def key
      read_encrypted_env_key || read_encrypted_key_file || super
    end

    private

    def read_encrypted_env_key
      from_encrypted_key(ENV[encrypted_env_key]) if ENV[encrypted_env_key]
    end

    def read_encrypted_key_file
      return unless File.exist?(encrypted_key_path)
      from_encrypted_key(IO.binread(encrypted_key_path).strip)
    end

    def from_encrypted_key(value)
      decrypt_master_key(value) if value
    end

    def decrypt_master_key(value)
      region = ENV['RAILS_MASTER_KEY_KMS_DECRYPTER_AWS_REGION'] || ENV['AWS_REGION']
      RailsMasterKeyKmsDecrypter::Decryption.new(region: region).decrypt(value).strip
    end
  end
end
