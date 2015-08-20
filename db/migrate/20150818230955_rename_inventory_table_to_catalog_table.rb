class RenameInventoryTableToCatalogTable < ActiveRecord::Migration
  def change
    rename_table :inventories, :catalogs
  end
end
