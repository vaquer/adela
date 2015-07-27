class OrganizationsController < ApplicationController
  before_action :authenticate_user!, except: [:catalog, :show, :search, :opening_plan]

  layout 'home'

  def show
    @organization = Organization.friendly.find(params[:id])
    @inventories = @organization.inventories.published.date_sorted.paginate(:page => params[:page], :per_page => 5)
    @current_month = params[:month] || I18n.l(Date.today.at_beginning_of_month, :format => "01-%m-%Y")
    @opening_plans = @organization.opening_plans.by_month(@current_month.to_date)
    if current_organization.present? && @organization.current_inventory && !@organization.current_catalog
      flash.now[:alert] = "OJO: No has completado el último paso que es publicar tu inventario."
    end
    respond_to do |format|
      format.html
      format.json { render json: @organization, root: false  }
    end
  end

  def publish_catalog
    if publication_requirements_checked?
      @catalog = current_organization.current_inventory
      @catalog.publish!
      record_activity("publish","publicó #{@catalog.datasets_count} conjuntos de datos con #{@catalog.distributions_count} recursos.")
      redirect_to inventories_path, :notice => "LISTO, has completados todos los pasos. Ahora utiliza esta herramienta para mantener tu programa de apertura e inventario de datos al día."
    end
  end

  def publish_later
    redirect_to organization_path(current_organization), :alert => "OJO: No has completado el último paso que es publicar tu inventario."
  end

  def catalog
    @organization = Organization.friendly.find(params[:slug])
    @inventory = @organization.current_catalog
    if @inventory.present?
      respond_to do |format|
        format.json { render json: @inventory, root: false }
      end
    else
      render :json => {}
    end
  end

  def opening_plan
    @organization  = Organization.friendly.find(params[:slug])
    respond_to do |format|
      format.json { render json: @organization, serializer: OrganizationOpeningPlanSerializer, root: false }
    end
  end

  def profile
    @organization = Organization.friendly.find(params[:id])

    if @organization != current_organization
      redirect_to organization_path(@organization)
    end
  end

  def update
    @organization = Organization.friendly.find(params[:id])

    if @organization.update(organization_params)
      redirect_to profile_organization_path(@organization), :notice => "El perfil se ha actualizado con éxito."
    else
      redirect_to profile_organization_path(@organization), :error => "Ha ocurrido un error al actualizar el perfil."
    end
  end

  def search
    @organizations = Organization.search_by(params[:q]).sort_by(&:current_datasets_count).reverse.paginate(:page => params[:page], :per_page => 5)
    @logs = ActivityLog.date_sorted
    @current_month = params[:month] || I18n.l(Date.today.at_beginning_of_month, :format => "01-%m-%Y")
    @opening_plans = OpeningPlan.by_month(@current_month.to_date)

    render "home/index"
  end

  private

  def publication_requirements_checked?
    requirements = [params[:personal_data], params[:open_data], params[:office_permission], params[:data_policy_requirements]]
    requirements.all? { |r| r == "1"}
  end

  def organization_params
    params.require(:organization).permit(:description, :logo_url, :gov_type)
  end
end
