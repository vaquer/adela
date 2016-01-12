class Dataset < ActiveRecord::Base
  include DatasetXLSXBuilder
  belongs_to :catalog

  has_many :distributions, dependent: :destroy

  has_one :dataset_sector, dependent: :destroy
  has_one :sector, through: :dataset_sector

  accepts_nested_attributes_for :dataset_sector

  def identifier
    title.to_slug.normalize.to_s
  end

  def publisher
    catalog.organization.title
  end

  def keywords
    "#{keyword},#{gov_type},#{sectors}".chomp(',').lchomp(',').downcase.strip
  end

  private

  def sectors
    catalog.organization.sectors.map(&:slug).join(',')
  end

  def gov_type
    catalog.organization.gov_type
  end
end
