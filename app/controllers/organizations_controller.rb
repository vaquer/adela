# TODO: needs refactoring
class OrganizationsController < ApplicationController
  before_action :authenticate_user!, except: [:catalog, :search, :opening_plans, :inventory]
  respond_to :csv, only: :inventory

  # TODO: move action to home#dashboard
  def show
    @organization = Organization.friendly.find(params[:id])
  end

  # TODO: move action to a controller under the API namespace
  def catalog
    @organization = Organization.friendly.find(params[:slug])
    @catalog = @organization.catalog
    if @catalog.present? && @catalog.distributions.map(&:published?).any?
      respond_to do |format|
        format.json { render json: @catalog, root: false }
      end
    else
      render json: {}
    end
  end

  def inventory
    @organization = Organization.friendly.find(params[:slug])
    @distributions = @organization.catalog.editable_datasets.map(&:distributions).flatten
    respond_with @distributions, style: :inventory
  end

  # TODO: use show action instead of this one
  def profile
    @organization = Organization.friendly.find(params[:id])
    redirect_to organization_path(@organization) unless @organization == current_organization
  end

  def update
    @organization = Organization.friendly.find(params[:id])

    if @organization.update(organization_params)
      redirect_to profile_organization_path(@organization), notice: 'El perfil se ha actualizado con éxito.'
    else
      redirect_to profile_organization_path(@organization), error: 'Ha ocurrido un error al actualizar el perfil.'
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:title, :description, :gov_type, :landing_page)
  end
end
