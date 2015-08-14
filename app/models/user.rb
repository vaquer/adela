class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  validates_presence_of :name

  scope :created_at_sorted, -> { order("created_at DESC") }

  belongs_to      :organization
  has_many        :inventories, :through => :organization
end
