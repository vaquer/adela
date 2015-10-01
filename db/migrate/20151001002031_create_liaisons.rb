class CreateLiaisons < ActiveRecord::Migration
  def change
    create_table :liaisons do |t|
      t.references :organization, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
