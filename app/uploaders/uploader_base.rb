class UploaderBase < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :fog

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def store_dir
    "uploads/#{model_name}/#{mounted_as}/#{model.id}"
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  private
  def model_name
    klass = model.class
    while klass.superclass != ActiveRecord::Base
      klass = klass.superclass
    end
    klass.to_s.underscore
  end
end
