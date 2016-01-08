class RemoveIdentifierFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :identifier, :string
  end
end
