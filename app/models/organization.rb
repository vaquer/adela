class Organization < ActiveRecord::Base
  validates_presence_of :title

  has_many :inventories
  has_many :users
end