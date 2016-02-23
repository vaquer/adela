class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader
  mount_uploader :authorization_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true

  has_many :activity_logs, as: :loggeable
  belongs_to :organization

  after_commit :create_catalog_datasets, on: :create

  private

  def create_catalog_datasets
    InventoryDatasetsWorker.perform_async(id)
  end
end
