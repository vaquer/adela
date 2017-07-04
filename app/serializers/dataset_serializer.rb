class DatasetSerializer < ActiveModel::Serializer
  has_many :distributions, root: :distribution, serializer: DistributionSerializer

  attributes :id, :title, :description, :issued, :modified, :identifier, :theme,
             :keyword, :language, :contactPoint, :temporal, :spatial, :govType,
             :accrualPeriodicity, :landingPage, :openessRating, :comments,
             :quality

  def attributes
    data = super
    data[:publisher] = {
      name: object.organization.title,
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
    contact_point_api_v1_dataset_url(object, format: :vcf).to_s
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
