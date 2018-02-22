# frozen_string_literal: true

require 'base64'
require 'aws-sdk-kms'

module RailsMasterKeyKmsDecrypter
  class Decryption
    attr_reader :client

    def initialize(client_options)
      @client = Aws::KMS::Client.new(client_options)
    end

    def decrypt(value, **options)
      decoded = Base64.strict_decode64(value)
      response = client.decrypt(ciphertext_blob: decoded, **options)
      response.plaintext
    end
  end
end
