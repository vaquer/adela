class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_presence_of :title

  has_many :inventories
  has_many :users

  def current_inventory
    inventories.unpublished.first
  end

  def current_catalog
    inventories.published.first
  end
end