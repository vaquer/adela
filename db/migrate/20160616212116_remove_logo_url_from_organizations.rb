class RemoveLogoUrlFromOrganizations < ActiveRecord::Migration
  def change
    remove_column :organizations, :logo_url, :string
  end
end
