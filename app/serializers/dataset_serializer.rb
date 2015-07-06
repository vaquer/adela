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
    data[:landingPage] = object.landingPage if version3?
    data
  end

  private

  def version3?
    object.class == DCAT::V3::DataSet
  end
end
