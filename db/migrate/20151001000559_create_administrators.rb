class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.references :organization, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
