class RemovePublishedFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :published, :boolean
  end
end
