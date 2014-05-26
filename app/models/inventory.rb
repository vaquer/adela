# encoding: utf-8
class Inventory < ActiveRecord::Base
  mount_uploader :csv_file, FileUploader

  validates_presence_of :organization_id, :csv_file
  validates_processing_of :csv_file
  validate :csv_encoding, :csv_structure

  belongs_to :organization

  scope :date_sorted, -> { order("created_at DESC") }
  scope :unpublished, -> { date_sorted.where(:published => false) }
  scope :published, -> { date_sorted.where(:published => true) }

  def csv_structure_valid?
    datasets.all? { |dataset| dataset.valid? }
  end

  def datasets
    @datasets ||= CsvProcessor.new(csv_file, organization).process
  end

  def csv_structure
    unless csv_right_encoding? && csv_structure_valid?
      errors.add(:csv_file)
    end
  end

  def publish!
    update_attributes(:published => true, :publish_date => DateTime.now)
  end

  def has_valid_datasets?
    datasets.map(&:valid?).count(true) >= 1
  end

  def public_datasets_count
    datasets.map(&:public?).count(true)
  end

  def private_datasets_count
    datasets.map(&:private?).count(true)
  end

  def csv_right_encoding?
    csv_content = csv_file.read || ""
    csv_content.force_encoding("utf-8").valid_encoding?
  end

  def csv_encoding
    unless csv_right_encoding?
      errors[:base] << I18n.t("activerecord.errors.models.inventory.attributes.csv_file.encoding")
    end
  end
end