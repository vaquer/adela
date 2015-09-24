class AddErrorMessageToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :error_message, :string
  end
end
