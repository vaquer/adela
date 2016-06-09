include ActiveModel::Serialization

class DatasetSerializer < ActiveModel::Serializer
  has_many :distributions, root: :distribution
  attributes :identifier, :title, :description, :modified, :contactPoint, :spatial

  def attributes
    data = super
    data[:language] = 'es'
    data[:publisher] = {
      name: object.publisher,
      mbox: object.mbox
    }
    data[:keyword] = object.keywords.split(',').map(&:squish)
    data[:landingPage] = object.landing_page
    data[:accrualPeriodicity] = object.accrual_periodicity
    data[:govType] = object.catalog.organization.gov_type
    data
  end

  def contactPoint
    object.contact_point
  end

  def distributions
    object.distributions.select(&:published?)
  end
end
