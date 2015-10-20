class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.text :title
      t.text :description
      t.text :download_url
      t.string :media_type
      t.integer :byte_size
      t.string :temporal
      t.string :spatial
      t.references :dataset, index: true

      t.timestamps
    end
  end
end
