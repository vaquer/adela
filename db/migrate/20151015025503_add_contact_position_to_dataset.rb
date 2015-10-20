class AddContactPositionToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :contact_position, :string
  end
end
