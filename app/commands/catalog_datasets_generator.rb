class CatalogDatasetsGenerator
  attr_reader :organization, :inventory

  def initialize(organization)
    @organization = organization
    @inventory = organization.inventories.order(created_at: :desc).find(&:compliant?)
  end

  def execute
    build_datasets.each do |dataset|
      build_distributions(dataset)
      build_sector(dataset) if @organization.sectors.present?
    end
    @organization.save
  end

  private

  def build_datasets
    @organization.opening_plans.map do |opening_plan|
      opening_plan_to_dataset(opening_plan)
    end
  end

  def opening_plan_to_dataset(opening_plan)
    @organization.catalog.datasets.create(
      identifier: opening_plan.name.downcase.split.join('-'),
      title: opening_plan.name,
      description: opening_plan.description,
      contact_position: ENV_CONTACT_POSITION_NAME,
      contact_point: organization_administrator.try(:name),
      mbox: organization_administrator.try(:email),
      landing_page: @organization.landing_page,
      accrual_periodicity: opening_plan.accrual_periodicity,
      publish_date: opening_plan.publish_date
    )
  end

  def build_distributions(dataset)
    select_distributions(dataset).map do |distribution|
      dataset.distributions.create(
        title: distribution.resource_title,
        description: distribution.description,
        media_type: distribution.media_type
      )
    end
  end

  def build_sector(dataset)
    dataset.create_dataset_sector do |dataset_sector|
      dataset_sector.sector_id = @organization.sectors.first.id
    end
  end

  def select_distributions(dataset)
    @inventory.inventory_elements.select { |element| element.dataset_title == dataset.title }
  end

  def organization_administrator
    @organization.administrator.try(:user)
  end
end
