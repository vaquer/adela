class DatasetsController < ApplicationController
  include DatasetActions
  before_action :authenticate_user!

  def index
    @catalog = current_organization.catalog
  end

  private

  def edit_customization
    @dataset.dataset_sector || @dataset.build_dataset_sector
  end

  def update_customization
    redirect_to organization_catalogs_path(current_organization)
    return
  end

  def dataset_params
    params.require(:dataset).permit(
      :title,
      :description,
      :publish_date,
      :accrual_periodicity,
      :contact_name,
      :contact_position,
      :mbox,
      :landing_page,
      :temporal,
      :spatial,
      :keyword,
      :comments,
      dataset_sector_attributes: [:sector_id]
    )
  end
end
