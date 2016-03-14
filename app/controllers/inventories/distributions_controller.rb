class Inventories::DistributionsController < ApplicationController
  include DistributionActions

  def confirm_destroy
    @distribution = Distribution.find(params[:id])
  end

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

  def distribution_params
    params.require(:distribution).permit(:title, :description, :media_type)
  end
end
