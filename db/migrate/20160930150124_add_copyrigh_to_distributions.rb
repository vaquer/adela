class AddCopyrighToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :copyright, :string
  end
end
