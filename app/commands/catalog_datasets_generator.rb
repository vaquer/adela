class CatalogDatasetsGenerator
  attr_reader :organization, :inventory

  def initialize(organization)
    @organization = organization
    @inventory = organization.inventories.order(created_at: :desc).find(&:compliant?)
  end

  def execute
    @organization.opening_plans.map do |opening_plan|
      create_or_update_dataset(opening_plan)
    end
  end

  private

  def create_or_update_dataset(opening_plan)
    if (dataset = find_dataset_by_title(opening_plan.name))
      update_dataset(dataset, opening_plan)
      create_new_distributions(dataset)
    else
      create_dataset_and_distributions(opening_plan)
    end
  end

  def create_dataset_and_distributions(opening_plan)
    dataset = create_dataset(opening_plan)
    create_sector(dataset)
    create_distributions(dataset)
  end

  def create_dataset(opening_plan)
    @organization.catalog.datasets.create(
      identifier: opening_plan.name.downcase.split.join('-').truncate(255),
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

  def create_sector(dataset)
    return unless @organization.sectors.present?
    dataset.create_dataset_sector do |dataset_sector|
      dataset_sector.sector_id = @organization.sectors.first.id
    end
  end

  def create_distributions(dataset)
    select_distributions(dataset).map do |distribution|
      dataset.distributions.create(
        title: distribution.resource_title,
        description: distribution.description,
        media_type: distribution.media_type
      )
    end
  end

  def update_dataset(dataset, opening_plan)
    dataset.update(
      description: opening_plan.description,
      accrual_periodicity: opening_plan.accrual_periodicity,
      publish_date: opening_plan.publish_date
    )
  end

  def create_new_distributions(dataset)
    select_distributions(dataset).map do |distribution|
      next if find_distribution_by_title(dataset, distribution.resource_title)
      dataset.distributions.create(
        title: distribution.resource_title,
        description: distribution.description,
        media_type: distribution.media_type
      )
    end
  end

  def select_distributions(dataset)
    @inventory.inventory_elements.select { |element| element.dataset_title.gsub("\n",'') == dataset.title }
  end

  def organization_administrator
    @organization.administrator.try(:user)
  end

  def find_dataset_by_title(title)
    @organization.catalog.datasets.where('title LIKE ?', title).first
  end

  def find_distribution_by_title(dataset, title)
    dataset.distributions.where('title LIKE ?', title).first
  end
end
