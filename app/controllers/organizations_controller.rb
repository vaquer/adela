class OrganizationsController < ApplicationController
  before_action :authenticate_user!, except: :catalog

  layout 'home'

  def show
    @organization = Organization.friendly.find(params[:id])
    if @organization.current_inventory && !@organization.current_catalog
      flash.now[:alert] = "OJO: No has completado el último paso que es publicar tu inventario."
    end
    unless @organization.inventories.any?
      redirect_to new_inventory_path
    end
  end

  def publish_catalog
    @organization = Organization.friendly.find(params[:id])
    if publication_requirements_checked?
      @organization.current_inventory.publish!
      redirect_to organization_path(@organization), :notice => "LISTO, has completados todos los pasos. Ahora utiliza esta herramienta para mantener tu plan de apertura e inventario de datos al día."
    else
      redirect_to publish_inventories_path, :error => "No se pudo publicar el catálogo"
    end
  end

  def publish_later
    @organization = Organization.friendly.find(params[:id])
    redirect_to organization_path(@organization), :alert => "OJO: No has completado el último paso que es publicar tu inventario."
  end

  def catalog
    @organization = Organization.friendly.find(params[:slug])
    @inventory = @organization.current_catalog
    if @inventory.present?
      Rabl.render(@inventory, "organizations/catalog", :view_path => 'app/views', :format => :json)
    end
  end

  private
  def publication_requirements_checked?
    requirements = [params[:personal_data], params[:open_data], params[:office_permission], params[:data_policy_requirements]]
    requirements.all? { |r| r == "1"}
  end
end