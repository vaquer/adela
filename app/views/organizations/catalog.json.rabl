collection @datasets, :root => false, :object_root => false

attributes :title, :description, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :format, :license, :spatial, :temporal

node :keyword do |dataset|
  dataset.keywords
end

node(:accessUrl, :if => lambda { |dataset| dataset.public? }) do |dataset|
  dataset.accessUrl
end