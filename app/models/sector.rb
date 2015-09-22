class Sector < ActiveRecord::Base
  validates :title, presence: true
end
