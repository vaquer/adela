class Dataset < ActiveRecord::Base
  belongs_to :catalog

  has_many :distributions, dependent: :destroy

  has_one :dataset_sector, dependent: :destroy
  has_one :sector, through: :dataset_sector

  accepts_nested_attributes_for :dataset_sector

  def next
    Dataset
      .where("catalog_id = #{catalog_id} AND id > #{id}")
      .order("id ASC")
      .first
  end

  def publisher
    catalog.organization.title
  end

  def keywords
    "#{keyword},#{sectors}".chomp(',').lchomp(',').downcase.strip
  end

  private

  def sectors
    catalog.organization.sectors.map(&:slug).join(',')
  end
end
