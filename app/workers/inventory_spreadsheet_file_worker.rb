class InventorySpreadsheetFileWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    parser = CatalogXLSXParser.new(inventory)
    parser.parse
  end
end
