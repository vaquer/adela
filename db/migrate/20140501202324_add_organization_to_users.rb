class AddOrganizationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organization_id, :integer
    # FIXME We should add an index on :organization_id
  end
end
