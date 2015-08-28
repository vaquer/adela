class InventoryRow
  include ActiveModel::Model

  attr_accessor :media_type, :responsible, :dataset_title, :resource_title,
                :dataset_description, :data_access_comment, :publish_date,
                :private_data, :number

  validates_presence_of :responsible, :dataset_title, :resource_title, :number,
                        :dataset_description, :media_type

  validates :private_data, inclusion: { in: [true, false] }

  validates_presence_of :publish_date, if: :public_data
  validate :iso8601_publish_date, :match_year_and_month, if: :public_data

  validates_presence_of :data_access_comment, if: :private_data

  def public_data
    !private_data
  end

  private

  def iso8601_publish_date
    ISO8601::DateTime.new(publish_date.to_s)
  rescue ISO8601::Errors::UnknownPattern
    errors.add(:publish_date)
  end

  def match_year_and_month
    errors.add(:publish_date) unless publish_date =~ /^(\d{4})-(\d{2})/
  end
end
