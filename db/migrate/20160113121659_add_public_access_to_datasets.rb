class AddPublicAccessToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :public_access, :boolean, default: true
  end
end
