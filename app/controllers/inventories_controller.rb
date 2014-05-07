class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @datasets = @inventory.datasets

    if @inventory.save
      redirect_to new_inventory_path, :notice => "El archivo se ha cargado exitosamente."
    else
      render :action => "new"
    end
  end

  private
  def inventory_params
    params.require(:inventory).permit(:csv_file, :organization_id)
  end
end