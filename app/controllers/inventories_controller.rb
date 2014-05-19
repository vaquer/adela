class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def new
    @inventory = current_user.inventories.unpublished.first
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.organization_id = current_organization.id
    @datasets = @inventory.datasets
    @inventory.save
    @upload_intent = true

    render :action => "new"
  end

  def publish
  end

  private

  def inventory_params
    params.require(:inventory).permit(:csv_file)
  end
end
