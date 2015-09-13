class AddAuthorToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :author, :string
  end
end
