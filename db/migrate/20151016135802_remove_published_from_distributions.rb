class RemovePublishedFromDistributions < ActiveRecord::Migration
  def change
    remove_column :distributions, :published, :boolean
  end
end
