# encoding: utf-8
class Inventory < ActiveRecord::Base
  String.include CoreExtensions::String::Transcoding

  mount_uploader :csv_file, FileUploader

  validates_presence_of :organization_id, :csv_file
  validates_processing_of :csv_file
  validate :csv_structure, :csv_datasets
  validates :csv_file, csv_file: true
  validates :datasets, datasets_titles: true

  belongs_to :organization

  scope :date_sorted, -> { order("created_at DESC") }
  scope :unpublished, -> { date_sorted.where(:published => false) }
  scope :published, -> { date_sorted.where(:published => true) }

  def csv_structure_valid?
    datasets.all? { |dataset| dataset.valid? }
  end

  def csv_datasets
    unless datasets.present?
      errors[:base] << I18n.t("activerecord.errors.models.inventory.attributes.datasets.blank")
    end
  end

  def datasets
    @datasets ||= CsvProcessor.new(csv_file, organization).process
  end

  def csv_structure
    unless csv_structure_valid?
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

  def datasets_count
    datasets.size
  end

  def distributions_count
    datasets.map(&:distributions_count).compact.sum
  end
end