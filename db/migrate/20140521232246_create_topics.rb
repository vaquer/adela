class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :organization_id
      t.string :name
      t.string :owner
      t.string :description
      t.integer :sort_order
      t.timestamps
    end
    add_index :topics, :organization_id
    add_index :topics, :sort_order
  end
end
