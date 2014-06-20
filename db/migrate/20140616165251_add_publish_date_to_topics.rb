class AddPublishDateToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :publish_date, :datetime
  end
end
