class AddRankedToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :ranked, :boolean, default: true
  end
end
