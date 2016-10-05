class AddQualityToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :quality, :string
  end
end
