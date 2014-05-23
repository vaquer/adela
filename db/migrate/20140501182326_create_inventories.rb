class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :file_location
      t.integer :organization_id

      t.timestamps
    end
    # FIXME We should add an index on :organization_id
  end
end
