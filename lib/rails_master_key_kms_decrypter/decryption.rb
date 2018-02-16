require 'base64'
require 'aws-sdk-kms'

module RailsMasterKeyKmsDecrypter
  class Decryption
    attr_reader :client

    def initialize(client_options)
      @client = Aws::KMS::Client.new(client_options)
    end

    def decrypt(value)
      decoded = Base64.decode64(value)
      response = client.decrypt(ciphertext_blob: decoded)
      response.plaintext
    end
  end
end
