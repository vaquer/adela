class InventorySerializer < ActiveModel::Serializer
  has_many :datasets, root: :dataset, serializer: DatasetSerializer

  def attributes
    data ||= {}
    data[:title] = "Catálogo de datos abiertos de #{object.organization.title}"
    data[:description] = ""
    data[:homepage] = ""
    data[:issued] = "#{object.organization.first_published_catalog.publish_date}"
    data[:modified] = "#{object.organization.current_catalog.publish_date}"
    data[:language] = "es"
    data[:license] = "http://datos.gob.mx/libreusomx/"
    data.merge super
  end
end
