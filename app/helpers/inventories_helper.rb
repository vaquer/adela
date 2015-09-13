module InventoriesHelper
  def inventory_compliant_elements?(inventory)
    inventory.inventory_elements.map(&:compliant?).all?
  end
end
