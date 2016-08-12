class Inventory < ActiveRecord::Base
  include Loggable

  mount_uploader :authorization_file, FileUploader
  mount_uploader :designation_file, FileUploader

  validates :organization, presence: true

  belongs_to :organization
end
