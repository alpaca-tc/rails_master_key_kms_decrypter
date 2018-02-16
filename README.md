# RailsMasterKeyKmsDecrypter

Dynamic decryptier of encrypted `config/master.key` on EC2.

---

Rails5.2 introduced [encrypted credentials](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2) 🙌

The key, located on `config/master.key` is created when you run rails new. It doesn't get committed to your repository.

If you using AWS and this gem, you can encrypt `config/master.key` to commit it. 
After encryping the key, the encrypted key will be saved to `config/master.key.enc`.

The default rails credential decryptor decrypts `config/credentials.yml.enc` from raw master key. 
After adding this gem, rails decrypts it from encrypted master key.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_master_key_kms_decrypter' # Recommended: `group: 'production'`
```

## Usage

### Rails Application

#### 1. Get your KMS key-id from AWS

Create the key at your region on [KMS](https://console.aws.amazon.com/iam/home#/encryptionKeys/)

#### 2. Encrypt your master.key or `RAILS_MASTER_KEY`

Encrypt your `config/master.key`

```sh
# Create `config/master.key.enc`
aws kms encrypt --key-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx --plaintext fileb://config/master.key --output text --query CiphertextBlob > config/master.key.enc
git add config/master.key.enc
git commit

# or define `ENCRYPTED_RAILS_MASTER_KEY`
ENCRYPTED_RAILS_MASTER_KEY=$(aws kms encrypt --key-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx --plaintext fileb://config/master.key --output text --query CiphertextBlob)
```

#### 3. Try to decrypt encrypted credentials

When rails credential decryption is succeeded, `rails_master_key_kms_decrypter` is ready.

```sh
ENCRYPTED_RAILS_MASTER_KEY=... ./bin/rails runner 'Rails.application.credentials.config.present? ? puts("👍") : puts("👎")'
```

### AWS resource

#### 1. Create the policy to allow access to KMS

[Create policy](https://console.aws.amazon.com/iam/home#/policies$new)

```
# Resource is your key
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "arn:aws:kms:ap-northeast-1:012345678900:key/1234567a-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  ]
}
```

#### 2. Create the role to allow access to KMS

[Create role](https://console.aws.amazon.com/iam/home#/roles$new)
Choose your resource and attach the policy from before.

#### 3. Attach IAM role to EC2

[Create EC2](https://ap-northeast-1.console.aws.amazon.com/ec2/v2/home?#LaunchInstanceWizard:) and deploy your application.

`RailsMasterKeyKmsDecrypter` need region information.
Please set `ENV["AWS_REGION"]` or `ENV["RAILS_MASTER_KEY_KMS_DECRYPTER_AWS_REGION"]`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/rails_master_key_kms_decrypter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
