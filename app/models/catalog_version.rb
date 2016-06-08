class CatalogVersion < ActiveRecord::Base
  belongs_to :catalog
  validates :catalog, :version, presence: true
end
