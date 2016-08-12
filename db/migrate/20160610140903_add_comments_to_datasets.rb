class AddCommentsToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :comments, :text
  end
end
