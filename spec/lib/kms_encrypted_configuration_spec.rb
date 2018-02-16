# frozen_string_literal: true

RSpec.describe RailsMasterKeyKmsDecrypter::KmsEncryptedConfiguration do
  let(:env_key) { 'RAILS_MASTER_KEY' }
  let(:key_path) { 'unexist/master.key' }
  let(:path) { File.expand_path('../../fixtures/credentials.yml.enc', __FILE__) }

  let(:instance) do
    described_class.new(
      config_path: path,
      key_path: key_path,
      env_key: env_key,
      raise_if_missing_key: false
    )
  end

  describe '#key' do
    subject { instance.key }

    before do
      stub_const('ENV', env)
    end

    let(:env) do
      {
        'AWS_REGION' => 'ap-northeast-1'
      }
    end

    context 'when RAILS_MASTER_KEY is exist' do
      let(:env) do
        super().merge(env_key => 'value')
      end

      it { is_expected.to eq('value') }
    end

    context 'when invalid ENCRYPTED_RAILS_MASTER_KEY is exist' do
      let(:env) do
        super().merge("ENCRYPTED_#{env_key}" => 'invalid')
      end

      it { is_expected.to be_nil }
    end

    context 'when valid ENCRYPTED_RAILS_MASTER_KEY is exist' do
      before do
        allow_any_instance_of(RailsMasterKeyKmsDecrypter::Decryption).to receive(:decrypt).and_return('value')
      end

      let(:env) do
        super().merge(
          "ENCRYPTED_#{env_key}" => 'valid'
        ) {}
      end

      it { is_expected.to eq('value') }
    end

    context 'when config/master.key is exist' do
      let(:key_path) { __FILE__ }
      it { is_expected.to eq File.read(__FILE__).strip }
    end

    context 'when config/master.key.enc is exist' do
      let(:key_path) { File.expand_path('../../fixtures/master.key', __FILE__) }

      before do
        allow_any_instance_of(RailsMasterKeyKmsDecrypter::Decryption).to receive(:decrypt).and_return('value')
      end

      it { is_expected.to eq 'value' }
    end
  end
end
