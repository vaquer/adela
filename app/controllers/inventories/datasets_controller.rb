class Inventories::DatasetsController < ApplicationController
  include DatasetActions

  before_action :authenticate_user!

  private

  def create_customization
    redirect_to inventories_path
    return
  end

  def update_customization
    redirect_to inventories_path
    return
  end

  def destroy_customization
    redirect_to inventories_path
    return
  end

  def dataset_params
    params.require(:dataset).permit(
      :title,
      :contact_position,
      :public_access,
      :publish_date,
      distributions_attributes: [:id, :title, :description, :media_type, :_destroy]
    )
  end
end
