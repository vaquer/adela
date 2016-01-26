class Catalog < ActiveRecord::Base
  belongs_to :organization

  has_many :datasets, dependent: :destroy
  has_many :distributions, through: :datasets

  validates_presence_of :organization_id

  accepts_nested_attributes_for :datasets

  def editable_datasets
    datasets.where(editable: true)
  end
end
