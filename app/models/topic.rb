class Topic < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name, :owner, :organization_id, :sort_order, :publish_date

  before_validation :set_sort_order

  scope :sorted, ->{ order("topics.sort_order ASC") }
  scope :updated_sorted, -> { order("topics.updated_at DESC")}
  scope :published, -> { where("topics.published" => true) }
  scope :publish_date_sorted, -> { order("topics.publish_date ASC") }

  def publish!
    self.update_attribute(:published, true)
  end

  def formatted_publish_date
    I18n.l(publish_date, :format => :short)
  end

  def publication_month_day
    publish_date.strftime('%e').to_i
  end

  def as_json(args={})
    args ||= {}
    super(args.merge!(:methods =>[:name, :owner, :organization_id, :sort_order, :formatted_publish_date, :description]))
  end

  def self.month_range
    self.pluck("to_char(publish_date, '01-MM-YYYY')").uniq
  end

  def self.year_range
    self.select("DISTINCT ON (to_char(topics.publish_date, 'YYYY')) topics.publish_date")
    .group("topics.publish_date")
    .order("to_char(topics.publish_date, 'YYYY') ASC, publish_date ASC")
    .map{ |topic| topic.publish_date.strftime("01-%m-%Y") }
  end

  def self.by_month(publish_date = Date.today)
    month_year = publish_date.strftime("01-%m-%Y")
    self.where("to_char(publish_date, '01-MM-YYYY') ='#{month_year}'")
  end

  def self.next_month_with_topics(current, organization = nil)
    current_month = Date.parse(current)
    if organization.present?
      sorted.where("topics.organization_id = #{organization} AND date(topics.publish_date) > '#{current_month.end_of_month}'").pluck("publish_date").first
    else
      sorted.where("date(topics.publish_date) > '#{current_month.end_of_month}'").pluck("publish_date").first
    end
  end

  def self.previous_month_with_topics(current, organization = nil)
    current_month = Date.parse(current)
    if organization.present?
      publish_date_sorted.where("topics.organization_id = #{organization} AND date(topics.publish_date) < '#{current_month.beginning_of_month}'").pluck("publish_date").first
    else
      publish_date_sorted.where("date(topics.publish_date) < '#{current_month.beginning_of_month}'").pluck("publish_date").first
    end
  end
  private

  def set_sort_order
    self.sort_order ||= (Topic.where("topics.organization_id = #{self.organization_id}").maximum("sort_order") || 0) + 1
  end
end
