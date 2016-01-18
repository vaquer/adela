class Inventories::DatasetsController < ApplicationController
  include DatasetActions

  before_action :authenticate_user!

  private

  def update_customization
    redirect_to inventories_path
    return
  end

  def destroy_customization
    redirect_to inventories_path
    return
  end

  def dataset_params
    params.require(:dataset).permit(:title, :public_access, :publish_date)
  end
end
