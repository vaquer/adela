class AddIndexToInventoriesAndUsers < ActiveRecord::Migration
  def change
    add_index :inventories, :organization_id
    add_index :users, :organization_id
  end
end
