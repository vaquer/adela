class AddPublishedToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :published, :boolean
  end
end
