include ActiveModel::Serialization

class DatasetSerializer < ActiveModel::Serializer
  has_many :distributions, root: :distribution
  attributes :identifier, :title, :description, :modified, :contact_point, :spatial

  def attributes
    data = super
    data[:language] = 'es'
    data[:publisher] = {
      name: object.publisher,
      mbox: object.mbox
    }
    data[:keyword] = object.keywords.split(',')
    data[:landing_page] = object.landing_page
    data
  end

  def distributions
    object.distributions.select(&:published?)
  end
end
