class OpeningPlan < ActiveRecord::Base
  belongs_to :organization
  has_many :officials, dependent: :destroy

  validates :vision, :name, :description, :publish_date, :officials, presence: true
  validates_associated :officials

  scope :publish_date_sorted, -> { order("opening_plans.publish_date ASC") }

  def self.by_month(publish_date = Date.today)
    month_year = publish_date.strftime("01-%m-%Y")
    self.where("to_char(publish_date, '01-MM-YYYY') ='#{month_year}'")
  end

  def self.next_month_with_topics(current, organization = nil)
    current_month = Date.parse(current)
    if organization.present?
      publish_date_sorted.where("opening_plans.organization_id = #{organization} AND date(opening_plans.publish_date) > '#{current_month.end_of_month}'").pluck("publish_date").first
    else
      publish_date_sorted.where("date(opening_plans.publish_date) > '#{current_month.end_of_month}'").pluck("publish_date").first
    end
  end

  def self.previous_month_with_topics(current, organization = nil)
    current_month = Date.parse(current)
    if organization.present?
      publish_date_sorted.where("opening_plans.organization_id = #{organization} AND date(opening_plans.publish_date) < '#{current_month.beginning_of_month}'").pluck("publish_date").first
    else
      publish_date_sorted.where("date(opening_plans.publish_date) < '#{current_month.beginning_of_month}'").pluck("publish_date").first
    end
  end

  def self.year_range
    self.select("DISTINCT ON (to_char(opening_plans.publish_date, 'YYYY')) opening_plans.publish_date")
    .group("opening_plans.publish_date")
    .order("to_char(opening_plans.publish_date, 'YYYY') ASC, publish_date ASC")
    .map{ |opening_plan| opening_plan.publish_date.strftime("01-%m-%Y") }
  end

  def self.month_range
    self.pluck("to_char(publish_date, '01-MM-YYYY')").uniq
  end

   def publication_month_day
    publish_date.day
  end
end
