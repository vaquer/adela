class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader
  mount_uploader :authorization_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true
  validate :duplicated_datasets, :compliant_elements, :non_empty

  belongs_to :organization

  has_many :inventory_elements, dependent: :destroy

  after_commit :create_inventory_elements, on: :create
  after_commit :create_catalog_datasets, on: :create

  def datasets
    dataset_titles.map do |title|
      inventory_elements.find { |element| element.dataset_title == title }
    end
  end

  private

  def create_inventory_elements
    InventoryXLSXParserWorker.perform_async(id)
  end

  def non_empty
    warnings.add(:inventory_elements) if inventory_elements.blank?
  end

  def compliant_elements
    warnings.add(:inventory_elements) unless inventory_elements.all?(&:compliant?)
  end

  def duplicated_datasets
    warnings.add(:inventory_elements, :duplicated) if duplicated_datasets?
  end

  def duplicated_datasets?
    dataset_titles.detect { |e| dataset_titles.count(e) > 1 }.present?
  end

  def dataset_titles
    inventory_elements.chunk(&:dataset_title).map(&:first)
  end

  def create_catalog_datasets
    InventorySpreadsheetFileWorker.perform_async(id)
  end
end
