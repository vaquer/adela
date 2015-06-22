class CreateOpeningPlans < ActiveRecord::Migration
  def change
    create_table :opening_plans do |t|
      t.references :organization, index: true
      t.text :vision
      t.text :name
      t.text :description
      t.date :publish_date

      t.timestamps
    end
  end
end
