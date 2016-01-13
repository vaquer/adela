class InventoryXLSXParserWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    inventory.inventory_elements.destroy_all
    InventoryXLSXParser.new(inventory).parse
    generate_dataset(inventory)
  end

  private

  def generate_dataset(inventory)
    InventoryDatasetGenerator.new(inventory).generate if inventory.valid?
  end
end
