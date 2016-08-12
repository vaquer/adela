class DatasetSerializer < ActiveModel::Serializer
  has_many :distributions, root: :distribution, serializer: DistributionSerializer

  attributes :id, :title, :description, :issued, :modified, :identifier, :keyword, :language,
             :contactPoint, :temporal, :spatial, :accrualPeriodicity, :landingPage, :openessRating,
             :govType, :theme, :comments

  def attributes
    data = super
    data[:publisher] = {
      name: object.contact_name,
      position: object.contact_position,
      mbox: object.mbox
    }
    data[:public] = object.public_access
    data[:publishDate] = object.publish_date
    data
  end

  def keyword
    object.keywords.split(',').map(&:squish)
  end

  def language
    'es'
  end

  def contactPoint
    "http://adela.datos.gob.mx/api/v1/datasets/#{object.id}/contact_point.vcf"
  end

  def accrualPeriodicity
    object.accrual_periodicity
  end

  def landingPage
    object.landing_page
  end

  def openessRating
    object.openess_rating
  end

  def govType
    object.catalog.organization.gov_type
  end

  def theme
    object.sector&.title
  end
end
