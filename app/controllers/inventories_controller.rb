class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_organization.inventory.update(inventory_params)
      flash[:notice] = I18n.t('flash.notice.inventory.update')
    end
    redirect_to inventories_path
  end

  private

  def inventory_params
    params.require(:inventory).permit(
      :authorization_file,
      :designation_file,
      :activity_log,
      activity_logs_attributes: [
        :message,
        :description,
        :organization_id
      ]
    )
  end
end
