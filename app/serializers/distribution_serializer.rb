class DistributionSerializer < ActiveModel::Serializer
  attributes :title, :description, :download_url, :media_type, :byte_size,
             :temporal, :spatial, :license

  def license
    'http://datos.gob.mx/libreusomx/'
  end
end
