class OpeningPlan < ActiveRecord::Base
  belongs_to :organization
  has_many :officials, dependent: :destroy

  validates :vision, :name, :description, :publish_date, :officials, presence: true
  validates_associated :officials
end
