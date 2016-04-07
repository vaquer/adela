class RemoveSpreadsheetFileAndErrorMessageFromInventories < ActiveRecord::Migration
  def change
    remove_column :inventories, :spreadsheet_file, :string
    remove_column :inventories, :error_message, :string
  end
end
