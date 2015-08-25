class RenameFileLocationToCsvFile < ActiveRecord::Migration
  def change
    rename_column :catalogs, :file_location, :csv_file
  end
end
