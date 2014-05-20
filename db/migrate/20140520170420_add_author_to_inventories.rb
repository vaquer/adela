class AddAuthorToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :author, :string
  end
end
