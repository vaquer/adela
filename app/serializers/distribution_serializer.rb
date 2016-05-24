class DistributionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :issued, :modified, :license, :downloadURL, :mediaType,
             :format, :byteSize, :temporal, :spatial, :publishDate

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

  def publishDate
    object.publish_date
  end
end
