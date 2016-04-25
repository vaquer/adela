class AddPublishDateToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :publish_date, :datetime
  end
end
