class CreateOfficials < ActiveRecord::Migration
  def change
    create_table :officials do |t|
      t.references :opening_plan, index: true
      t.string :name
      t.string :position
      t.integer :kind
      t.string :email

      t.timestamps
    end
  end
end
