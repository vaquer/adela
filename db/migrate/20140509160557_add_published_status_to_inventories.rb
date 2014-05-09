class AddPublishedStatusToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :published, :boolean, :default => false
  end
end