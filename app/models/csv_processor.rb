class CsvProcessor < Struct.new(:csv_file, :organization)
  String.include CoreExtensions::String::Transcoding

  def process
    datasets = []
    if csv_file.url.present?
      CSV.new(csv_file.read.to_utf8, :headers => :first_row).each do |row|
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
          csv << dataset_csv_row(dataset_obj) if dataset_obj.valid?
        elsif distribution?(row)
          distribution_obj = new_distribution(row)
          dataset_obj.distributions << distribution_obj
          csv << "#{dataset_obj.identifier},,,,,,,,,,,,," + distribution_obj.values_array.to_csv if (dataset_obj.valid? || (dataset_obj.public? && distribution_obj.downloadURL))
        end
      end
    end
  end

  private

  def csv_header_fields
    %w[
      ds:identifier ds:title  ds:description  ds:keyword  ds:modified ds:contactPoint ds:mbox ds:accessLevel  ds:accessLevelComment ds:temporal ds:spatial  ds:dataDictionary ds:accrualPeriodicity rs:title  rs:description  rs:downloadURL  rs:mediaType  rs:byteSize rs:temporal rs:spatial  rs:accrualPeriodicity
    ].to_csv
  end

  def dataset_csv_row(dataset)
    ds_columns = dataset.values_array
    rs_columns = [nil, nil, nil, nil, nil, nil, nil, nil]
    (ds_columns + rs_columns).to_csv
  end

  def new_dataset(row)
    DataSet.new({
      :identifier => I18n.transliterate((row["ds:identifier"] || row[0]).force_encoding('utf-8')),
      :title => row["ds:title"],
      :description => row["ds:description"],
      :keyword => row["ds:keyword"],
      :modified => row["ds:modified"],
      :contactPoint => row["ds:contactPoint"],
      :mbox => row["ds:mbox"],
      :accessLevel => row["ds:accessLevel"],
      :accessLevelComment => row["ds:accessLevelComment"],
      :temporal => row["ds:temporal"],
      :spatial => row["ds:spatial"],
      :dataDictionary => row["ds:dataDictionary"],
      :accrualPeriodicity => row["accrualPeriodicity"],
      :publisher => organization.title
    })
  end

  def new_distribution(row)
    Distribution.new({
      :title => row["rs:title"],
      :description => row["rs:description"],
      :downloadURL => row["rs:downloadURL"],
      :mediaType => row["rs:mediaType"],
      :byteSize => row["rs:byteSize"],
      :temporal => row["rs:temporal"],
      :spatial => row["rs:spatial"],
      :accrualPeriodicity => row["rs:accrualPeriodicity"]
    })
  end

  def dataset?(row)
    (row["ds:identifier"].present? || row[0].present?) && row["ds:title"].present?
  end

  def distribution?(row)
    (row["ds:identifier"].present? || row[0].present?) && row["rs:title"].present?
  end
end