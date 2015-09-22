class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  validates_presence_of :title

  has_many :catalogs
  has_many :users
  has_many :activity_logs
  has_many :opening_plans, dependent: :destroy
  has_many :inventories
  has_many :organization_sectors
  has_many :sectors, through: :organization_sectors

  accepts_nested_attributes_for :opening_plans

  scope :with_catalog, -> { joins(:catalogs).where("catalogs.published = 't'").uniq }
  scope :title_sorted, -> { order("organizations.title ASC") }
  scope :federal, -> { where("gov_type = ?", Organization.gov_types[:federal]) }
  scope :state, -> { where("gov_type = ?", Organization.gov_types[:state]) }
  scope :municipal, -> { where("gov_type = ?", Organization.gov_types[:municipal]) }
  scope :autonomous, -> { where("gov_type = ?", Organization.gov_types[:autonomous]) }

  enum gov_type: [:federal, :state, :municipal, :autonomous]

  def unpublished_catalog
    catalogs.unpublished.first
  end

  def current_catalog
    catalogs.published.first
  end

  def last_file_version
    catalogs.date_sorted.first
  end

  def last_catalog_is_unpublished?
    current_catalog && last_file_version && (current_catalog.id != last_file_version.id)
  end

  def first_published_catalog
    catalogs.published.last
  end

  def last_activity_at
    activity_logs.date_sorted.first.done_at if activity_logs.any?
  end

  def current_datasets_count
    if unpublished_catalog.present?
      unpublished_catalog.datasets_count
    else
      0
    end
  end

  def self.search_by(q)
    if q.present?
      where("organizations.title ~* ?", q)
    else
      self.all
    end
  end
end
