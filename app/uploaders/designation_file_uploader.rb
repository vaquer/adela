class DesignationFileUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.organization.slug}/#{mounted_as}/#{model.id}"
  end
end
