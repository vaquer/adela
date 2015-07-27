class AddGovTypeToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :gov_type, :integer
    add_index :organizations, :gov_type
  end
end
