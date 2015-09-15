class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :trackable, :validatable
  rolify

  scope :created_at_sorted, -> { order('created_at DESC') }

  validates_presence_of :name

  has_many :catalogs, through: :organization
  belongs_to :organization
end
