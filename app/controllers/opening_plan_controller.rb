class OpeningPlanController < ApplicationController
  before_action :authenticate_user!, except: %i(export)

  def index
    @organization = current_organization
    if @organization.inventory.present? && @organization.opening_plans.empty?
      redirect_to new_opening_plan_path
    end
  end

  def new
    @organization = current_organization
    cloned_organization = @organization.deep_clone :include => [:opening_plans]
    @organization.opening_plans = []
    build_opening_plan_from_inventory(cloned_organization.opening_plans) unless @organization.inventory.nil?
  end

  def create
    @organization = current_organization
    @organization.opening_plans = []
    @organization.update(organization_params)
    @organization.save
    redirect_to opening_plan_index_path
  end

  def organization
    @organization = Organization.find(params[:id])
  end

  def export
    organization = Organization.find(params[:id])
    exporter = OpeningPlanExporter.new(organization)
    respond_to do |format|
      format.csv { send_data exporter.export }
    end
  end

  private

  def build_opening_plan_from_inventory(current_plan)
    @organization.inventory.datasets.each do |element|
      build_opening_plans(element, current_plan) unless element.private?
    end
  end

  def build_opening_plans(element, current_plan)
    @organization.opening_plans.build do |plan|
      plan.name = element.dataset_title
      plan.publish_date = element.publish_date

      current_plan.each do |ds|
        if element.dataset_title == ds.name
          plan.description = ds.description
          plan.accrual_periodicity = ds.accrual_periodicity
          plan.publish_date = ds.publish_date
        end
      end

    end
  end

  def organization_params
    params.require(:organization).permit(
      opening_plans_attributes: [
        :name,
        :description,
        :accrual_periodicity,
        :publish_date
      ]
    )
  end
end
