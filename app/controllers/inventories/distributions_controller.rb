class Inventories::DistributionsController < ApplicationController
  include DistributionActions

  private

  def create_customization
    redirect_to inventories_path
    return
  end

  def distribution_params
    params.require(:distribution).permit(:title, :description, :media_type)
  end
end
