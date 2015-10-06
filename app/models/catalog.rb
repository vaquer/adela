class Catalog < ActiveRecord::Base
  belongs_to :organization
  validates_presence_of :organization_id

  # TODO: remove uploader after migrating data from csv to database
  mount_uploader :csv_file, FileUploader
end
