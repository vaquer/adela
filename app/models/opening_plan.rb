class OpeningPlan < ActiveRecord::Base
  validates :name, :publish_date, :accrual_periodicity, presence: true

  has_many :officials, dependent: :destroy
  belongs_to :organization
end
