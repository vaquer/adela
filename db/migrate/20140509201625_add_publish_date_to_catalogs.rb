class AddPublishDateToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :publish_date, :datetime
  end
end
