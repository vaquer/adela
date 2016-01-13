class Catalog < ActiveRecord::Base
  belongs_to :organization
  has_many :datasets, dependent: :destroy
  has_many :distributions, through: :datasets

  validates_presence_of :organization_id

  # TODO: remove uploader after migrating data from csv to database
  mount_uploader :csv_file, FileUploader
  accepts_nested_attributes_for :datasets
end
