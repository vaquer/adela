class Inventory < ActiveRecord::Base
  mount_uploader :csv_file, FileUploader

  validates_presence_of :organization_id, :csv_file
  validates_processing_of :csv_file
  validate :csv_structure

  belongs_to :organization

  scope :date_sorted, -> { order("created_at DESC") }

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
          :accessUrl => dataset["accessURL"]
        })
      end
    end
    datasets
  end

  def datasets
    @datasets ||= process_csv
  end

  def csv_structure
    unless csv_structure_valid?
      errors.add(:csv_file)
    end
  end

  def publish!
    update_attribute(:published, true)
  end
end