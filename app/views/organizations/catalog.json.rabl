object @inventory => ""

node :title do |inventory|
  "Catálogo de datos abiertos de #{inventory.organization.title}"
end

node :description do
  ""
end

node :homepage do
  ""
end

node :issued do |inventory|
  "#{inventory.organization.first_published_catalog.publish_date}"
end

node :modified do |inventory|
  "#{inventory.organization.current_catalog.publish_date}"
end

node :language do
  "es"
end

node :license do
  "http://datos.gob.mx/tos/"
end

child :datasets => :dataset do |inventory|
  attributes :title, :description, :modified, :contactPoint, :identifier, :accessLevel, :accessLevelComment, :license, :spatial

  node :language do
    "es"
  end

  node :publisher do |dataset|
    attributes :name => dataset.publisher, :mbox => dataset.mbox
  end

  node :keyword do |dataset|
    dataset.keywords
  end

  child :distributions => :distribution do |dataset|
    attributes :spatial, :temporal, :accrualPeriodicity, :title, :description, :mediaType, :downloadURL

    node :license do
      "http://datos.gob.mx/tos/"
    end
  end
end