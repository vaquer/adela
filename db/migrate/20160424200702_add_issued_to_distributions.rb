class AddIssuedToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :issued, :datetime
  end
end
