include ActiveModel::Serialization

class DatasetSerializer < ActiveModel::Serializer
  attributes :title, :description, :modified, :contactPoint, :identifier, :accessLevel, :accessLevelComment, :spatial
  has_many :distributions, root: :distribution

  def attributes
    data = super
    data[:language] = "es"
    data[:publisher] = {
      :name => object.publisher,
      :mbox => object.mbox
    }
    data[:keyword] = object.keywords
    data
  end
end
