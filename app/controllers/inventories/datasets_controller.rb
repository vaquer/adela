class Inventories::DatasetsController < ApplicationController
  include DatasetActions

  before_action :authenticate_user!

  def update_customization
    redirect_to inventories_path
    return
  end

  private

  def dataset_params
    params.require(:dataset).permit(:title, :public_access, :publish_date)
  end
end
