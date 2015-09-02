class InventoryXLSXParserWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    inventory.inventory_elements.destroy_all
    InventoryXLSXParser.new(inventory).parse
  end
end
