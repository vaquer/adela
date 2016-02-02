class OpeningPlansController < ApplicationController
  before_action :authenticate_user!, except: [:export]
  before_action :require_published_datasets, only: [:index]

  def export
    organization = Organization.find(params[:id])
    exporter = OpeningPlanExporter.new(organization)
    respond_to do |format|
      format.csv { send_data exporter.export }
    end
  end

  private

  def require_published_datasets
    return if current_inventory && current_organization.catalog.datasets.where(public_access: true, published: true, editable: true).present?
    redirect_to new_opening_plan_path
  end
end
