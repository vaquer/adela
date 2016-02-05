class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    current_organization.inventories.create(inventory_params)
    redirect_to inventories_path
  end

  private

  def inventory_params
    params.require(:inventory).permit(:spreadsheet_file, :authorization_file)
  end
end
