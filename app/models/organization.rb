class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_presence_of :title

  has_many :inventories
  has_many :users
  has_many :topics
  has_many :activity_logs

  scope :with_catalog, -> { joins(:inventories).where("inventories.published = 't'").uniq }

  def current_inventory
    inventories.unpublished.first
  end

  def current_catalog
    inventories.published.first
  end

  def last_file_version
    inventories.date_sorted.first
  end

  def old_file_versions
    inventories.date_sorted.offset(1)
  end

  def last_inventory_is_unpublished?
    current_catalog && last_file_version && (current_catalog.id != last_file_version.id)
  end

  def first_published_catalog
    inventories.published.last
  end

  def last_updated_topic
    topics.updated_sorted.first
  end

  def has_public_topics?
    topics.published.any?
  end
end