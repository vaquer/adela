class AddBooleanFieldsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :planea, :boolean
    add_column :organizations, :publica, :boolean
    add_column :organizations, :perfecciona, :boolean
    add_column :organizations, :promueve, :boolean
    add_column :organizations, :plan_inventario, :boolean
    add_column :organizations, :designaciones, :boolean
  end
end
