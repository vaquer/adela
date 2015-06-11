class Official < ActiveRecord::Base
  validates :name, :position, :email, :kind, presence: true
  belongs_to :opening_plan
  enum kind: [ :liaison, :admin ]
end
