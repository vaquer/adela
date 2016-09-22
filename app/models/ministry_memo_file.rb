class MinistryMemoFile < ActiveRecord::Base
  belongs_to :organization
  validates :organization, presence: true

  mount_uploader :file, MinistryMemoFileUploader
  validates_presence_of :file
end
