class AddIndexToCatalogsAndUsers < ActiveRecord::Migration
  def change
    add_index :catalogs, :organization_id
    add_index :users, :organization_id
  end
end
