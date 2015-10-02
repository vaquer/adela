class Official < ActiveRecord::Base
  belongs_to :opening_plan
  enum kind: [:liaison, :admin]
end
