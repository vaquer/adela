class AddLandingPageToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :landing_page, :text
  end
end
