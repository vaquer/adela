class CreateOrganizationSectors < ActiveRecord::Migration
  def change
    create_table :organization_sectors do |t|
      t.references :sector, index: true
      t.references :organization, index: true

      t.timestamps
    end
  end
end
