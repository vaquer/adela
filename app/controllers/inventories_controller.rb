class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to new_inventory_path if current_organization.inventory.nil?
    @inventory = current_organization.inventory
    @new_inventory = Inventory.new
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = current_organization.build_inventory(intentory_params)
    @inventory.save
    redirect_to inventory_path(@inventory)
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.update(intentory_params)
    redirect_to inventory_path(@inventory)
  end

  def show
    @inventory = Inventory.find(params[:id])
  end

  def publish
    @inventory = Inventory.find(params[:id])
    # TODO: create inventory dataset
    redirect_to organization_path(current_organization)
  end

  private

  def intentory_params
    params.require(:inventory).permit(:spreadsheet_file, :authorization_file)
  end
end
