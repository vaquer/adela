class CatalogXLSXParser
  def initialize(inventory)
    @inventory = inventory
    @organization = inventory.organization
    @catalog = organization_catalog
  end

  def parse
    xlsx = Roo::Spreadsheet.open(spreadsheet_file)
    (xlsx.first_row..xlsx.last_row).drop(1).map do |row|
      xlsx_row = xlsx.row(row)
      Dataset.build_from_xlsx_row(@catalog, xlsx_row)
    end
  rescue => e
    @inventory.update_column(:error_message, e.message)
  end

  private

  def spreadsheet_file
    Rails.env.production? ? @inventory.spreadsheet_file.url : @inventory.spreadsheet_file
  end

  def organization_catalog
    @organization.catalog.present? ? @organization.catalog : build_catalog
  end

  def build_catalog
    @organization.create_catalog(published: false)
  end
end
