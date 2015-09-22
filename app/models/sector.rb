class Sector < ActiveRecord::Base
  has_many :organization_sectors, dependent: :destroy
  has_many :organizations, through: :organization_sectors
  validates :title, presence: true
end
