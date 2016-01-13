class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to new_inventory_path unless current_inventory
    @inventory = current_inventory
    @new_inventory = Inventory.new
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = current_organization.inventories.build(inventory_params)
    @inventory.save
    redirect_to inventory_path(@inventory)
  end

  def show
    @inventory = Inventory.find(params[:id])
  end

  private

  def inventory_params
    params.require(:inventory).permit(:spreadsheet_file, :authorization_file)
  end
end
