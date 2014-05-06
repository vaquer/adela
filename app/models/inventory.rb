class Inventory < ActiveRecord::Base
  mount_uploader :csv_file, FileUploader

  validates_presence_of :organization_id
  validates_processing_of :csv_file

  belongs_to :organization

  scope :date_sorted, -> { order("created_at DESC") }

  def csv_structure_valid?
    valid = []
    datasets.each do |dataset|
      valid << dataset.valid?
    end
    valid.all?
  end

  def datasets
    datasets = []
    if csv_file.url.present?
      CSV.foreach(csv_file.url, :headers => true) do |dataset|
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
end