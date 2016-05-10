class AddContactNameToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :contact_name, :string
  end
end
