class FetchOpeningPlanCommand
  String.include CoreExtensions::String::Transcoding
  include ActiveModel::Validations

  attr_accessor :dataset, :organization

  validates :dataset, :organization, presence: true

  def initialize(dataset, organization)
    @dataset = dataset
    @organization = organization
  end

  def execute!
    download_and_create_opening_plan
  end

  private

  def download_and_create_opening_plan
    download_urls.each do |url|
      csv_content = download_opening_plan(url)
      parse_and_create_opening_plan(csv_content)
    end
  end

  def download_urls
    @dataset.distributions.map(&:downloadURL)
  end

  def download_opening_plan(url)
    response = HTTParty.get(url)
    response.body.to_utf8
  end

  def parse_and_create_opening_plan(csv_content)
    CSV.new(csv_content).each do |row|
      create_opening_plan(row)
    end
  end

  def create_opening_plan(row)
    opening_plan = build_opening_plan_from_row(row)
    opening_plan.officials.build(name: row[1], position: row[2], email: row[3], kind: "liaison")
    opening_plan.officials.build(name: row[4], position: row[5], email: row[6], kind: "admin")
    opening_plan.save
  end

  def build_opening_plan_from_row(row)
    @organization.opening_plans.build(
      vision: row[0],
      name: row[7],
      description: row[8],
      publish_date: row[9],
    )
  end
end
