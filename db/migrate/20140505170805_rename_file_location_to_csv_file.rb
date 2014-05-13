class RenameFileLocationToCsvFile < ActiveRecord::Migration
  def change
    rename_column :inventories, :file_location, :csv_file
  end
end
