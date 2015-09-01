class CreateInventoryElements < ActiveRecord::Migration
  def change
    create_table :inventory_elements do |t|
      t.integer :row
      t.text :responsible
      t.text :dataset_title
      t.text :resource_title
      t.text :description
      t.boolean :private
      t.text :access_comment
      t.string :media_type
      t.date :publish_date
      t.references :inventory, index: true

      t.timestamps
    end
  end
end
