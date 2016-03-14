class AddDesignationFileToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :designation_file, :string
  end
end
