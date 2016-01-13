class InventoryDatasetGenerator
  attr_reader :inventory, :organization, :catalog

  def initialize(inventory)
    @inventory = inventory
    @organization = inventory.organization
    @catalog = organization_catalog
  end

  def generate
    if inventory_dataset.present?
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
    dataset = inventory_dataset
    dataset.modified = Time.current.iso8601
    dataset.distributions.first
    dataset.save
  end

  def update_distribution
    distribution = inventory_dataset.distributions.first
    distribution.download_url = @inventory.spreadsheet_file.url
    distribution.byte_size = @inventory.spreadsheet_file.file.size
    distribution.modified = Time.current.iso8601
    distribution.temporal = build_temporal(distribution.modified)
    distribution.save
  end

  def inventory_dataset
    @catalog.datasets.where("title LIKE 'Inventario Institucional de Datos de #{@organization.title}'").last
  end

  def create_dataset_and_distribution
    dataset = build_dataset
    build_distribution(dataset)
    build_sector(dataset) if @organization.sectors.present?
    dataset.save
  end

  def organization_catalog
    @organization.catalog.present? ? @organization.catalog : build_catalog
  end

  def build_catalog
    @organization.create_catalog(published: false)
  end

  def build_dataset
    @catalog.datasets.build do |dataset|
      dataset.title = "Inventario Institucional de Datos de #{@organization.title}"
      dataset.description = "Inventario Institucional de Datos de #{@organization.title}"
      dataset.keyword = 'inventario'
      dataset.modified = Time.current.iso8601
      dataset.contact_position = ENV_CONTACT_POSITION_NAME
      dataset.contact_point = organization_administrator.try(:name)
      dataset.mbox = organization_administrator.try(:email)
      dataset.temporal = Time.current.year
      dataset.landing_page = @organization.landing_page
      dataset.accrual_periodicity = 'irregular'
      dataset.publish_date = DateTime.new(2015, 8, 28)
    end
  end

  def organization_administrator
    @organization.administrator.try(:user)
  end

  def build_sector(dataset)
    dataset.build_dataset_sector do |dataset_sector|
      dataset_sector.sector_id = @organization.sectors.first.id
    end
  end

  def build_temporal(date)
    "P3H33M/" + date.strftime("%FT%T%:z")
  end


  def build_distribution(dataset)
    dataset.distributions.build do |distribution|
      distribution.title = "Inventario Institucional de Datos de #{@organization.title}"
      distribution.description = "Inventario Institucional de Datos de #{@organization.title}"
      distribution.download_url = @inventory.spreadsheet_file.url
      distribution.media_type = 'application/vnd.ms-excel'
      distribution.byte_size = @inventory.spreadsheet_file.file.size
      distribution.temporal = build_temporal(dataset.modified)
      distribution.modified = dataset.modified
    end
  end
end
