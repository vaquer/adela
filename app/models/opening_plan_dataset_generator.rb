class OpeningPlanDatasetGenerator
  attr_reader :catalog

  def initialize(catalog)
    @catalog = catalog
  end

  def generate
    dataset = build_dataset
    build_distribution(dataset)
    build_sector(dataset) if @catalog.organization.sectors.present?
    @catalog.save
  end

  private

  def build_dataset
    @catalog.datasets.build do |dataset|
      dataset.identifier = "#{@catalog.organization.slug}-plan-de-apertura-institucional"
      dataset.title = "Plan de Apertura Institucional de #{@catalog.organization.title}"
      dataset.description = "Plan de Apertura Institucional de #{@catalog.organization.title}"
      dataset.keyword = 'plan-de-apertura'
      dataset.modified = Time.current.iso8601
      dataset.contact_position = ENV_CONTACT_POSITION_NAME
      dataset.contact_point = organization_administrator.try(:name)
      dataset.mbox = organization_administrator.try(:email)
      dataset.temporal = Time.current.year
      dataset.landing_page = @catalog.organization.landing_page
      dataset.accrual_periodicity = 'irregular'
      dataset.publish_date = DateTime.new(2015, 9, 25)
    end
  end

  def build_sector(dataset)
    dataset.build_dataset_sector do |dataset_sector|
      dataset_sector.sector_id = @catalog.organization.sectors.first.id
    end
  end

  def build_distribution(dataset)
    dataset.distributions.build do |distribution|
      distribution.title = "Plan de Apertura Institucional de #{@catalog.organization.title}"
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
