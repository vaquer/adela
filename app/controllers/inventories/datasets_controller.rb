class Inventories::DatasetsController < ApplicationController
  include DatasetActions
  include InventoryActions
  before_action :authenticate_user!

  def confirm_destroy
    @dataset = Dataset.find(params[:id])
  end

  private

  def index_customization
    @datasets = @datasets.where(editable: true).order("#{params[:sort]} #{params[:direction]}")
  end

  def create_customization
    if @dataset.valid?
      redirect_to inventories_datasets_path
      return
    end
    render :new
    return
  end

  def update_customization
    if @dataset.valid?
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

  def dataset_params
    params.require(:dataset).permit(
      :title,
      :description,
      :contact_position,
      :public_access,
      :accrual_periodicity,
      :publish_date,
      distributions_attributes: [
        :id,
        :title,
        :description,
        :publish_date,
        :media_type,
        :format,
        :_destroy
      ]
    )
  end
end
