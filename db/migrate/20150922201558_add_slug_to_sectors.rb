class AddSlugToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :slug, :string
    add_index :sectors, :slug, unique: true
  end
end
