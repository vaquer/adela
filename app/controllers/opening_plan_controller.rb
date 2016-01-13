class OpeningPlanController < ApplicationController
  before_action :authenticate_user!, except: %i(export)

  def index
    @organization = current_organization
    if current_inventory.present? && @organization.opening_plans.empty?
      redirect_to new_opening_plan_path
    end
  end

  def new
    @organization = current_organization
  end

  def create
    @organization = current_organization
    @organization.opening_plans = []
    @organization.update(organization_params)
    create_opening_plan_officials
    generate_catalog_datasets
    generate_opening_plan_dataset
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
    current_inventory.datasets.each do |element|
      next if current_plan.map(&:name).include?(element.dataset_title)
      build_opening_plans(element, current_plan) unless element.private?
    end
  end

  def build_opening_plans(element, current_plan)
    @organization.opening_plans.build do |plan|
      plan.name = element.dataset_title
      plan.publish_date = element.publish_date
    end
  end

  def create_opening_plan_officials
    @organization.opening_plans.each do |opening_plan|
      administrator = create_opening_plan_administrator(opening_plan)
      liaison = create_opening_plan_liaison(opening_plan)
    end
  end

  def create_opening_plan_administrator(opening_plan)
    user = @organization.administrator.try(:user)
    return unless user
    opening_plan.officials.create(email: user.email, name: user.name, kind: 'admin')
  end

  def create_opening_plan_liaison(opening_plan)
    user = @organization.liaison.try(:user)
    return unless user
    opening_plan.officials.create(email: user.email, name: user.name, kind: 'liaison')
  end

  def generate_opening_plan_dataset
    OpeningPlanDatasetGenerator.new(@organization.catalog).generate
  end

  def organization_params
    params.require(:organization).permit(
      opening_plans_attributes: [
        :name,
        :description,
        :accrual_periodicity,
        :publish_date,
        :_destroy
      ]
    )
  end
end
