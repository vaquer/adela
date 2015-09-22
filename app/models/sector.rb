class Sector < ActiveRecord::Base
  has_many :organization_sectors
  has_many :organizations, through: :organization_sectors
  validates :title, presence: true
end
