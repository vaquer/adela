class AddMinistryToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :ministry, :boolean, default: false
  end
end
