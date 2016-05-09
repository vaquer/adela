class AddFormatToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :format, :string
  end
end
