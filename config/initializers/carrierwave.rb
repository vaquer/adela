CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :aws
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end

  config.aws_bucket = ENV['S3_BUCKET_NAME']
  config.aws_acl    = :public_read
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV['AMAZON_ACCESS_KEY'],
    secret_access_key: ENV['AMAZON_SECRET_KEY'],
    region:            ENV['AWS_REGION']
  }
end
