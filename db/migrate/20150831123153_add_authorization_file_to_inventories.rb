class AddAuthorizationFileToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :authorization_file, :string
  end
end
