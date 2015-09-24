class ChangeMediaTypeToTextInInventoryElements < ActiveRecord::Migration
  def up
    change_column :inventory_elements, :media_type, :text
  end

  def down
    change_column :inventory_elements, :media_type, :string
  end
end
