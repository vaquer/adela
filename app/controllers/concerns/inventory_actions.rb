module InventoryActions
  extend ActiveSupport::Concern

  included do
    after_action :inventory_dataset, only: [:create, :edit, :update, :destroy]
  end

  private

  def inventory_dataset
    InventoryDatasetsWorker.perform_async(current_organization.inventory.id)
  end
end
