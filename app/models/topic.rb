class Topic < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name, :owner, :organization_id, :sort_order

  before_validation :set_sort_order

  scope :sorted, ->{ order("topics.sort_order ASC") }


  private

  def set_sort_order
    self.sort_order ||= (Topic.maximum("sort_order") || 0) + 1
  end
end
