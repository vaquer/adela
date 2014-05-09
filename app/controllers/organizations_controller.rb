class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def show
  end

  def publish_catalog
    @organization = Organization.friendly.find(params[:id])
    if publication_requirements_checked?
      @organization.current_inventory.publish!
      redirect_to publish_inventories_path, :notice => "El catálogo de datos se ha publicado correctamente."
    else
      redirect_to publish_inventories_path, :error => "No se pudo publicar el catálogo"
    end
  end

  private
  def publication_requirements_checked?
    requirements = [params[:personal_data], params[:open_data], params[:office_permission], params[:data_policy_requirements]]
    requirements.all? { |r| r == "1"}
  end
end