class DropInventoryElements < ActiveRecord::Migration
  def change
    drop_table :inventory_elements
  end
end
