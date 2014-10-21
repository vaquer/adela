class DistributionSerializer < ActiveModel::Serializer
  attributes :spatial, :temporal, :accrualPeriodicity, :title, :description, :mediaType, :downloadURL, :license

  def license
    "http://datos.gob.mx/libreusomx/"
  end
end
