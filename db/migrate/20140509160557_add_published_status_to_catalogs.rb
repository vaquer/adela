class AddPublishedStatusToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :published, :boolean, default: false
  end
end
