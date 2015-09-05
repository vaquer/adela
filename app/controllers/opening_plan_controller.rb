class OpeningPlanController < ApplicationController
  before_action :authenticate_user!

  def new
    @organization = current_organization
    @organization.opening_plans = []
    build_opening_plan_from_inventory unless @organization.inventory.nil?
  end

  def create
    @organization = current_organization
    @organization.opening_plans = []
    @organization.update(organization_params)
    @organization.save
    redirect_to organization_opening_plan_path(@organization)
  end

  def organization
    @organization = Organization.find(params[:id])
  end

  private

  def build_opening_plan_from_inventory
    @organization.inventory.inventory_elements.each do |element|
      build_opening_plans(element) unless element.private?
    end
  end

  def build_opening_plans(element)
    @organization.opening_plans.build do |plan|
      plan.name = element.dataset_title
      plan.publish_date = element.publish_date
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
