class Inventory < ActiveRecord::Base
  mount_uploader :csv_file, FileUploader

  validates_presence_of :organization_id
  validates_processing_of :csv_file

  belongs_to :organization

  def validate_csv_structure
  end
end