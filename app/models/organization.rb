class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_presence_of :title

  has_many :inventories
  has_many :users

  def current_inventory
    inventories.date_sorted.first
  end
end