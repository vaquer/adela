class InventoryDatasetsWorker
  include Sidekiq::Worker

  def perform(inventory_id)
    inventory = Inventory.find(inventory_id)
    create_inventory_dataset(inventory)
  end

  private

  def create_inventory_dataset(inventory)
    return unless inventory.valid?
    generator = OpeningPlanDatasetGenerator.new(inventory)
    generator.generate
  end
end
