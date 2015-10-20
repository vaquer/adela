class AddModifiedToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :modified, :datetime
  end
end
