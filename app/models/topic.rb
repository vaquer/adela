class Topic < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name, :owner, :organization_id, :sort_order
end
