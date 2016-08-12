class ActivityLog < ActiveRecord::Base
  belongs_to :loggeable, polymorphic: true
  belongs_to :organization

  scope :date_sorted, -> { order("created_at DESC") }
  scope :first_block, -> { date_sorted.limit(5) }
  scope :last_block, -> { date_sorted.limit(10).offset(5) }

  validates :message, :organization, presence: true
end
