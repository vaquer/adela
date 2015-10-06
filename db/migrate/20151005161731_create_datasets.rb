class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :identifier
      t.text :title
      t.text :description
      t.text :keyword
      t.datetime :modified
      t.string :contact_point
      t.string :mbox
      t.string :temporal
      t.string :spatial
      t.text :landing_page
      t.string :accrual_periodicity
      t.references :catalog, index: true

      t.timestamps
    end
  end
end
