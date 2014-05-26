class CsvProcessor < Struct.new(:csv_file, :organization)
  def process
    datasets = []
    if csv_file.url.present?
      CSV.new(csv_file.read, :headers => :first_row).each do |row|
        if dataset?(row)
          datasets << new_dataset(row)
        elsif distribution?(row)
          datasets.last.distributions << new_distribution(row)
        end
      end
    end
    datasets
  end

  def generate_csv(temporary_path)
    dataset_obj = nil
    File.open(temporary_path, "w") do |csv|
      csv << csv_header_fields
      CSV.foreach(csv_file, :headers => :first_row).each do |row|
        if dataset?(row)
          dataset_obj = new_dataset(row)
          csv << dataset_obj.values_array.to_csv if dataset_obj.valid?
        elsif distribution?(row)
          distribution_obj = new_distribution(row)
          dataset_obj.distributions << distribution_obj
          csv << "#{dataset_obj.identifier},,,,,,,,,,," + distribution_obj.values_array.to_csv if (dataset_obj.valid? || (dataset_obj.public? && distribution_obj.downloadURL))
        end
      end
    end
  end

  private

  def csv_header_fields
    %w[
      ds:identifier  ds:title  ds:description  ds:keyword  ds:modified ds:contactPoint ds:mbox ds:accessLevel  ds:accessLevelComment ds:license  ds:spatial  rs:spatial  rs:temporal rs:accrualPeriodicity rs:title  rs:description  rs:downloadURL  rs:mediaType
    ].to_csv
  end

  def new_dataset(row)
    DataSet.new({
      :title => row["ds:title"],
      :description => row["ds:description"],
      :keyword => row["ds:keyword"],
      :modified => row["ds:modified"],
      :publisher => organization.title,
      :contactPoint => row["ds:contactPoint"],
      :mbox => row["ds:mbox"],
      :identifier => row["ds:identifier"],
      :accessLevel => row["ds:accessLevel"],
      :accessLevelComment => row["ds:accessLevelComment"],
      :license => row["ds:license"],
      :spatial => row["ds:spatial"]
    })
  end

  def new_distribution(row)
    Distribution.new({
      :spatial => row["rs:spatial"],
      :temporal => row["rs:temporal"],
      :accrualPeriodicity => row["rs:accrualPeriodicity"],
      :title => row["rs:title"],
      :description => row["rs:description"],
      :downloadURL => row["rs:downloadURL"],
      :mediaType => row["rs:mediaType"]
    })
  end

  def dataset?(row)
    row["ds:identifier"] && row["ds:title"]
  end

  def distribution?(row)
    row["ds:identifier"] && row["rs:title"]
  end
end