collection @datasets, :root => false, :object_root => false

attributes :title, :description, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :license, :spatial

node :keyword do |dataset|
  dataset.keywords
end

child :distributions, :root => false, :object_root => false do |dataset|
  attributes :spatial, :temporal, :accrualPeriodicity, :title, :description, :mediaType, :downloadURL
end