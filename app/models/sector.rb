class Sector < ActiveRecord::Base
  extend FriendlyId

  has_many :organization_sectors, dependent: :destroy
  has_many :organizations, through: :organization_sectors
  validates :title, presence: true
  friendly_id :title, use: [:slugged]
end
