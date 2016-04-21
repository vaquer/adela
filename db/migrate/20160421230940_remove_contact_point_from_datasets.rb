class RemoveContactPointFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :contact_point, :string
  end
end
