class AddIssuedToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :issued, :datetime
  end
end
