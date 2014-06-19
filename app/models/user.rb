class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name

  scope :created_at_sorted, -> { order("created_at DESC") }

  belongs_to      :organization
  has_many        :inventories, :through => :organization
end
