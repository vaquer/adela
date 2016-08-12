module Versionable
  extend ActiveSupport::Concern

  included do
    after_commit :add_catalog_version
  end

  private

  def add_catalog_version
    CatalogVersion.create(catalog: catalog, version: catalog_serializable_hash)
  end

  def catalog_serializable_hash
    InventoriesSerializer.new(catalog).serializable_hash
  end
end
