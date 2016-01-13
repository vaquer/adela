# TODO: rename file to something more accurate
class InventoryXLSXParserWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    generate_dataset(inventory)
  end

  private

  def generate_dataset(inventory)
    InventoryDatasetGenerator.new(inventory).generate if inventory.valid?
  end
end
