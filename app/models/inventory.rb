class Inventory < ActiveRecord::Base
  include Loggable
  validates :organization, presence: true
  belongs_to :organization
end
