class AddEditableColumnToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :editable, :boolean
  end
end
