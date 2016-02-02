class OpeningPlanDatasetGenerator
  attr_reader :catalog

  def initialize(catalog)
    @catalog = catalog
  end

  def generate
    if opening_plan_dataset.present?
      update_dataset_and_distribution
    else
      create_dataset_and_distribution
    end
  end

  private

  def update_dataset_and_distribution
    update_dataset
    update_distribution
  end

  def update_dataset
    dataset = opening_plan_dataset
    dataset.modified = Time.current.iso8601
    dataset.save
  end

  def update_distribution
    distribution = opening_plan_dataset.distributions.first
    distribution.modified = Time.current.iso8601
    distribution.save
  end

  def create_dataset_and_distribution
    dataset = build_dataset
    build_distribution(dataset)
    build_sector(dataset) if @catalog.organization.sectors.present?
    dataset.save
  end

  def opening_plan_dataset
    @catalog.datasets.where("title LIKE 'Plan de Apertura Institucional de #{@catalog.organization.title}'").last
  end

  def build_dataset
    @catalog.datasets.build do |dataset|
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
      dataset.editable = false
      dataset.published = true
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
      distribution.media_type = 'csv'
      distribution.temporal = "#{Date.new(2015, 9, 25)}/#{Date.new(2016, 9, 26)}"
      distribution.modified = Date.today
    end
  end

  def organization_administrator
    @catalog.organization.administrator.try(:user)
  end
end
