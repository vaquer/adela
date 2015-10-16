class CatalogsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_opening_plan

  def index
    redirect_to catalog_datasets_path(current_organization.catalog)
    return
  end

  def check
    @catalog = current_organization.catalog
  end

  def publish
    @catalog = current_organization.catalog
    @catalog.publish_date = Time.current
    @catalog.save
    publish_distributions
    redirect_to catalog_path(@catalog)
    return
  end

  private

  def publish_distributions
    distributions = @catalog.datasets.map(&:distributions).flatten.select(&:validated?)
    distributions.each do |distribution|
      distribution.update_column(:state, 'published')
    end
  end

  def require_opening_plan
    return if current_organization.opening_plans.present?
    render :error
    return
  end
end
