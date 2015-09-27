CarrierWave.configure do |config|

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region: 'ap-northeast-1'
  }

  case Rails.env
    when 'production'
      config.fog_directory = 'survey.bizevo.net'
      config.fog_public = true
      config.cache_storage = :fog
      config.cache_dir = "#{Rails.root}/tmp/uploads"

    when 'development'
      config.storage = :fog
      config.fog_directory = 'survey-develop'
      config.fog_public = true
      config.cache_storage = :fog
      config.cache_dir = "#{Rails.root}/tmp/uploads"

    when 'test'
      config.fog_directory = 'test.dummy'
      config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/test.dummy'
  end
end
