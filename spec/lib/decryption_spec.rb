# frozen_string_literal: true

RSpec.describe RailsMasterKeyKmsDecrypter::Decryption do
  describe '#decrypt' do
    subject { instance.decrypt(value) }
    let(:instance) { described_class.new(region: 'ap-northeast-1') }

    context 'given valid value' do
      # aws kms encrypt --key-id xxx --plaintext fileb://<(echo "hello world") --output text --query CiphertextBlob
      let(:value) { 'AQICAHiFVeg2mwmE39ysBtph0yeqHDsJpNxrzlUu5fcguztrKgGLe4r4yqk9OZ0dOsvhmxgZAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMpCjtzRCEI1eo1Rq0AgEQgCdmcJdYz0VERhvtDIV6iVJ989DTKVt1fm6ubL9Z05Ox38q9orP8RAA=' }

      let(:response) do
        Aws::KMS::Types::DecryptResponse.new(
          key_id: 'arn:aws:kms:ap-northeast-1:079362918680:key/3494756a-bc9d-45fe-965b-e303216071a6',
          plaintext: "hello world\n"
        )
      end

      before do
        allow_any_instance_of(Aws::Plugins::ParamConverter::Handler).to receive(:call).and_return(response)
      end

      it { is_expected.to eq("hello world\n") }
    end

    context 'given invalid region' do
      before do
        allow_any_instance_of(Aws::Plugins::ParamConverter::Handler).to receive(:call).and_raise(Aws::KMS::Errors::SubscriptionRequiredException.new('', ''))
      end

      let(:value) { 'AQICAHiFVeg2mwmE39ysBtph0yeqHDsJpNxrzlUu5fcguztrKgGLe4r4yqk9OZ0dOsvhmxgZAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMpCjtzRCEI1eo1Rq0AgEQgCdmcJdYz0VERhvtDIV6iVJ989DTKVt1fm6ubL9Z05Ox38q9orP8RAA=' }
      it { expect { subject }.to raise_error(Aws::KMS::Errors::SubscriptionRequiredException) }
    end

    context 'given invalid value' do
      let(:value) { 'AQICAHiF' }
      it { expect { subject }.to raise_error(Aws::Errors::ServiceError) }
    end
  end
end
