class DatasetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @catalog = current_organization.catalog
  end

  def edit
    @dataset = Dataset.find(params['id'])
    @dataset.dataset_sector || @dataset.build_dataset_sector
  end

  def update
    @dataset = Dataset.find(params['id'])
    @dataset.update(dataset_params)
    render nothing: true
    return
  end

  private

  def dataset_params
    params.require(:dataset).permit(
      :title,
      :description,
      :publish_date,
      :accrual_periodicity,
      :contact_position,
      :mbox,
      :landing_page,
      :temporal,
      :spatial,
      :keyword,
      dataset_sector_attributes: [:sector_id]
    )
  end
end
