class Dataset < ActiveRecord::Base
  belongs_to :catalog
  has_many :distributions, dependent: :destroy

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
