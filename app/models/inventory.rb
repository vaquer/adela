class Inventory < ActiveRecord::Base
  validates_presence_of :file_location, :organization

  belongs_to :organization
end
