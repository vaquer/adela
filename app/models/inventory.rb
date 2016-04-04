class Inventory < ActiveRecord::Base
  include Loggable

  mount_uploader :authorization_file, FileUploader
  mount_uploader :designation_file, FileUploader

  validates :organization, presence: true

  belongs_to :organization

  after_commit :create_catalog_datasets, on: :create

  private

  def create_catalog_datasets
    InventoryDatasetsWorker.perform_async(id)
  end
end
