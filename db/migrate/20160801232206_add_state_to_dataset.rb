class AddStateToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :state, :string
  end
end
