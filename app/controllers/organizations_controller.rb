class OrganizationsController < ApplicationController
  before_action :authenticate_user!, except: :catalog

  layout 'home'

  def show
    @organization = Organization.friendly.find(params[:id])
    if current_organization.present? && @organization.current_inventory && !@organization.current_catalog
      flash.now[:alert] = "OJO: No has completado el último paso que es publicar tu inventario."
    end
  end

  def publish_catalog
    if publication_requirements_checked?
      @catalog = current_organization.current_inventory
      @catalog.publish!
      record_activity "publicó #{@catalog.datasets_count} conjuntos de datos con #{@catalog.distributions_count} recursos."
      redirect_to organization_path(current_organization), :notice => "LISTO, has completados todos los pasos. Ahora utiliza esta herramienta para mantener tu programa de apertura e inventario de datos al día."
    end
  end

  def publish_later
    redirect_to organization_path(current_organization), :alert => "OJO: No has completado el último paso que es publicar tu inventario."
  end

  def catalog
    @organization = Organization.friendly.find(params[:slug])
    @inventory = @organization.current_catalog
    if @inventory.present?
      Rabl.render(@inventory, "organizations/catalog", :view_path => 'app/views', :format => :json)
    else
      render :json => {}
    end
  end

  private
  def publication_requirements_checked?
    requirements = [params[:personal_data], params[:open_data], params[:office_permission], params[:data_policy_requirements]]
    requirements.all? { |r| r == "1"}
  end
end
