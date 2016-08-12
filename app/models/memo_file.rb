class MemoFile < ActiveRecord::Base
  belongs_to :organization
  validates :organization, presence: true

  mount_uploader :file, MemoFileUploader
  validates_presence_of :file
end
