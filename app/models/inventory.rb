class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader
  mount_uploader :authorization_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true

  belongs_to :organization
  has_many :inventory_elements

  def valid_rows?
    rows.all?(&:valid?)
  end

  def rows
    InventoryXLSXParser.new(self).parse
  end
end
