class Topic < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name, :owner, :organization_id, :sort_order, :publish_date

  before_validation :set_sort_order

  scope :sorted, ->{ order("topics.sort_order ASC") }
  scope :updated_sorted, -> { order("topics.updated_at DESC")}
  scope :published, -> { where("topics.published" => true) }

  def publish!
    self.update_attribute(:published, true)
  end

  def formatted_publish_date
    I18n.l(publish_date, :format => :short)
  end

  def as_json(args={})
    args ||= {}
    super(args.merge!(:methods =>[:name, :owner, :organization_id, :sort_order, :formatted_publish_date, :description]))
  end

  private

  def set_sort_order
    self.sort_order ||= (Topic.where("topics.organization_id = #{self.organization_id}").maximum("sort_order") || 0) + 1
  end
end
