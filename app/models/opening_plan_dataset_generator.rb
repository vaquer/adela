class OpeningPlanDatasetGenerator
  attr_reader :catalog

  def initialize(catalog)
    @catalog = catalog
  end

  def generate
    dataset = build_dataset
    build_distribution(dataset)
    @catalog.save
  end

  private

  def build_dataset
    @catalog.datasets.build do |dataset|
      dataset.identifier = 'plan-de-apertura-institucional'
      dataset.title = 'Plan de Apertura Institucional'
      dataset.description = "Plan de Apertura Institucional de #{@catalog.organization.title}"
      dataset.keyword = 'plan-de-apertura'
      dataset.modified = Time.current.iso8601
      dataset.contact_point = organization_administrator.try(:name)
      dataset.mbox = organization_administrator.try(:email)
      dataset.temporal = Time.current.year
      # TODO: add dct:landing_page field
      # dataset.landing_page = Faker::Internet.url
      dataset.accrual_periodicity = 'irregular'
    end
  end

  def build_distribution(dataset)
    dataset.distributions.build do |distribution|
      distribution.title = 'Plan de Apertura Institucional'
      distribution.description = "Plan de Apertura Institucional de #{@catalog.organization.title}"
      distribution.download_url = "http://adela.datos.gob.mx/plan-de-apertura/#{@catalog.organization.slug}/export.csv"
      distribution.media_type = 'text/csv'
      distribution.temporal = Time.current.year
    end
  end

  def organization_administrator
    @catalog.organization.administrator.try(:user)
  end
end
