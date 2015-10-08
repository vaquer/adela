class Dataset < ActiveRecord::Base
  belongs_to :catalog
  has_many :distributions, dependent: :destroy

  def publisher
    catalog.organization.title
  end
end
