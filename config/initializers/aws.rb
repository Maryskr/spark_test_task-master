Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(Rails.application.secrets.aws_key, Rails.application.secrets.aws_secret),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(Rails.application.secrets.aws_basket)
