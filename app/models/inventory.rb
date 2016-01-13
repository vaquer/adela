class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader
  mount_uploader :authorization_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true

  belongs_to :organization

  after_commit :create_inventory_elements, on: :create
  after_commit :create_catalog_datasets, on: :create

  private

  # TODO: rename method to something more expresive
  def create_inventory_elements
    InventoryXLSXParserWorker.perform_async(id)
  end

  def create_catalog_datasets
    InventorySpreadsheetFileWorker.perform_async(id)
  end
end
