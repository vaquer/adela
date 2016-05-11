class InventoriesSerializer < ActiveModel::Serializer
  has_many :datasets, root: :dataset, serializer: Inventories::DatasetsSerializer

  def attributes
    data ||= {}
    data[:title] = "Inventario de Datos de #{object.organization.title}"
    data.merge super
  end
end
