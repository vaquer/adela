class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader
  mount_uploader :authorization_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true

  belongs_to :organization

  has_many :inventory_elements, dependent: :destroy

  after_save :create_inventory_elements

  private

  def create_inventory_elements
    InventoryXLSXParserWorker.perform_async(id)
  end
end
