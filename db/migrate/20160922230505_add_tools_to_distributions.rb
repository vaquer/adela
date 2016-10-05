class AddToolsToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :tools, :text
  end
end
