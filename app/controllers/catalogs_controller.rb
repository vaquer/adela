class CatalogsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_opening_plan

  def index
    redirect_to catalog_datasets_path(current_organization.catalog)
    return
  end

  def show
    @catalog = current_organization.catalog
  end

  def check
    @datasets = catalog_params['distribution_ids'].map do |id|
      Distribution.find(id).dataset
    end
  end

  def publish
    @catalog = current_organization.catalog
    @catalog.publish_date = Time.current
    @catalog.save
    publish_distributions
    harvest_catalog
    notify_administrator
    redirect_to catalog_path(@catalog)
    return
  end

  private

  def catalog_params
    params.require(:catalog).permit(distribution_ids: [])
  end

  def notify_administrator
    administrator = @catalog.organization.administrator
    CatalogMailer.publish_email(@catalog.id, administrator.user.id).deliver_now if administrator
  end

  def publish_distributions
    catalog_params['distribution_ids'].each do |id|
      distribution = Distribution.find(id)
      distribution.update_column(:state, 'published')
    end
  end

  def harvest_catalog
    slug = @catalog.organization.slug
    ShogunHarvestWorker.perform_async("http://adela.datos.gob.mx/#{slug}/catalogo.json")
  end

  def require_opening_plan
    return if current_organization.opening_plans.present?
    render :error
    return
  end
end
