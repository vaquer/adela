class CreateDatasetSectors < ActiveRecord::Migration
  def change
    create_table :dataset_sectors do |t|
      t.references :sector, index: true
      t.references :dataset, index: true

      t.timestamps
    end
  end
end
