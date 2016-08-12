class RemoveCsvFileFromCatalogs < ActiveRecord::Migration
  def change
    remove_column :catalogs, :csv_file, :string
  end
end
