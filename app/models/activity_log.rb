class ActivityLog < ActiveRecord::Base

  belongs_to :organization

  scope :date_sorted, -> { order("activity_logs.done_at DESC") }
end
