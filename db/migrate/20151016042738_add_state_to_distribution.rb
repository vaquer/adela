class AddStateToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :state, :string
  end
end
