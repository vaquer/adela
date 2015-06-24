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

  private

  def new_dataset(row)
    DCAT::V2::DataSet.new({
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
