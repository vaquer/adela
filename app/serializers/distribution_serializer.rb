class DistributionSerializer < ActiveModel::Serializer
  attributes :title, :description, :license, :downloadURL, :mediaType, :byteSize

  def license
    "http://datos.gob.mx/libreusomx/"
  end
end
