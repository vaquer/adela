class OpeningPlansController < ApplicationController
  before_action :authenticate_user!, except: %i(export)

  def index
    @organization = current_organization
    if current_inventory.present? && @organization.catalog.datasets.where(published: true).blank?
      redirect_to new_opening_plan_path
    end
  end

  def new
    @organization = current_organization
  end

  def export
    organization = Organization.find(params[:id])
    exporter = OpeningPlanExporter.new(organization)
    respond_to do |format|
      format.csv { send_data exporter.export }
    end
  end

  private

  def generate_opening_plan_dataset
    OpeningPlanDatasetGenerator.new(@organization.catalog).generate
  end
end
