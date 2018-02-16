module RailsMasterKeyKmsDecrypter
  class KmsEncryptedConfiguration < ActiveSupport::EncryptedConfiguration
    attr_reader :encrypted_env_key, :encrypted_key_path

    def initialize(content_path:, key_path:, env_key:, raise_if_missing_key:)
      super

      @encrypted_env_key = "#{key_path}.enc"
      @encrypted_key_path = "ENCRYPTED_#{env_key}"
    end<`0`>

    def key
      read_encrypted_env_key || read_encrypted_key_file || super
    end

    private

    def from_encrypted_key(value)
      decrypt_master_key(value) if value
    rescue
      nil
    end

    def read_encrypted_env_key
      from_encrypted_key(ENV[encrypted_env_key]) if ENV[encrypted_env_key]
    end

    def read_encrypted_key_file
      from_encrypted_key(IO.binread(encrypted_key_path).strip) if File.exist?(encrypted_key_path)
    end

    def decrypt_master_key(value)
      region = ENV['RAILS_MASTER_KEY_KMS_DECRYPTER_AWS_REGION'] || ENV['AWS_DEFAULT_REGION']
      RailsMasterKeyKmsDecrypter.new(region: region).decrypt(value)
    end
  end
end
