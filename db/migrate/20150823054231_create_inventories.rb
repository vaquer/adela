class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :spreadsheet_file
      t.references :organization, index: true

      t.timestamps
    end
  end
end
