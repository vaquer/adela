class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :trackable, :validatable
  rolify

  scope :created_at_sorted, -> { order('created_at DESC') }
  scope :email, -> (email) { where('lower(email) LIKE ?', "%#{email.downcase}%") }
  scope :names, -> (name) { where('lower(name) LIKE ?', "%#{name.downcase}%") }
  scope :organization, -> (organization_id) { where(organization_id: organization_id) }

  validates_presence_of :name

  has_many :catalogs, through: :organization
  belongs_to :organization
end
