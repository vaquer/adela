class InventoryDatasetsWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    create_inventory_dataset(inventory)
    create_catalog_datasets_from_spreadsheet_file(inventory)
  end

  private

  def create_inventory_dataset(inventory)
    return unless inventory.valid?
    generator = InventoryDatasetGenerator.new(inventory)
    generator.generate
  end

  def create_catalog_datasets_from_spreadsheet_file(inventory)
    parser = CatalogXLSXParser.new(inventory)
    parser.parse
  end
end
