class CreateCatalogVersions < ActiveRecord::Migration
  def change
    create_table :catalog_versions do |t|
      t.references :catalog, index: true, foreign_key: true
      t.json :version

      t.timestamps null: false
    end
  end
end
