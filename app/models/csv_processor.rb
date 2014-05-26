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