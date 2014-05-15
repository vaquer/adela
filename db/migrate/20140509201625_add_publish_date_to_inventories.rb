class AddPublishDateToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :publish_date, :datetime
  end
end