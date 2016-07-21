class DatasetsController < ApplicationController
  include DatasetActions
  before_action :authenticate_user!

  private

  def index_customization
    @catalog = current_organization.catalog
    @datasets = @datasets.where(public_access: true)
                         .order("#{params[:sort]} #{params[:direction]}")
                         .select { |dataset| dataset.valid?(:catalog) }
  end

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
