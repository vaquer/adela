class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :file_location
      t.integer :organization_id

      t.timestamps
    end
  end
end
