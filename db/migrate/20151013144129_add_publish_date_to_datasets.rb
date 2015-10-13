class AddPublishDateToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :publish_date, :datetime
  end
end
