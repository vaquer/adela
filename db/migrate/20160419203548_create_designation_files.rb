class CreateDesignationFiles < ActiveRecord::Migration
  def change
    create_table :designation_files do |t|
      t.string :file
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
