class Inventories::DistributionsController < ApplicationController
  include DistributionActions
  include InventoryActions

  def confirm_destroy
    @distribution = Distribution.find(params[:id])
  end

  private

  def create_customization
    if @distribution.valid?
      redirect_to inventories_datasets_path
      return
    end
    render :new
    return
  end

  def update_customization
    if @distribution.valid?
      redirect_to inventories_datasets_path
      return
    end
    render :edit
    return
  end

  def destroy_customization
    redirect_to inventories_datasets_path
    return
  end

  def distribution_params
    params.require(:distribution).permit(:title, :description, :publish_date, :media_type, :format)
  end
end
