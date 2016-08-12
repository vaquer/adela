class CatalogSerializer < ActiveModel::Serializer
  has_many :datasets, root: :dataset, serializer: Catalog::DatasetSerializer

  def attributes
    data ||= {}
    data[:title] = "Catálogo de datos abiertos de #{object.organization.title}"
    data[:description] = ''
    data[:homepage] = ''
    data[:issued] = "#{object.created_at}"
    data[:modified] = "#{object.publish_date}"
    data[:language] = 'es'
    data[:license] = 'http://datos.gob.mx/libreusomx/'
    data.merge super
  end

  def datasets
    object.datasets.select do |dataset|
      dataset.distributions.map(&:published?).any?
    end
  end
end
