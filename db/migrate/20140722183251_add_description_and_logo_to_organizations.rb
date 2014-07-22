class AddDescriptionAndLogoToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :description, :text
    add_column :organizations, :logo_url, :string
  end
end
