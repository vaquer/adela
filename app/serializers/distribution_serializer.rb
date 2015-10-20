class DistributionSerializer < ActiveModel::Serializer
  attributes :title, :description, :downloadURL, :mediaType, :byteSize,
             :temporal, :spatial, :license

  def license
    'http://datos.gob.mx/libreusomx/'
  end

  def downloadURL
    object.download_url
  end

  def mediaType
    object.media_type
  end

  def byteSize
    object.byte_size
  end
end
