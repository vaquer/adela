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

  def process_csv
    datasets = []
    if csv_file.url.present?
      CSV.new(csv_file.read, :headers => :first_row).each do |dataset|
        datasets << DataSet.new({
          :title => dataset["title"],
          :description => dataset["description"],
          :keyword => dataset["keyword"],
          :modified => dataset["modified"],
          :publisher => dataset["publisher"],
          :contactPoint => dataset["contactPoint"],
          :mbox => dataset["mbox"],
          :identifier => dataset["identifier"],
          :accessLevel => dataset["accessLevel"],
          :accessLevelComment => dataset["accessLevelComment"],
          :accessUrl => dataset["accessURL"],
          :format => dataset["format"],
          :license => dataset["license"],
          :spatial => dataset["spatial"],
          :temporal => dataset["temporal"]
        })
      end
    end
    datasets
  end

  def datasets
    @datasets ||= process_csv
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