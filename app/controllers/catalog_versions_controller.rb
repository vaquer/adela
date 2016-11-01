class CatalogVersionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @catalog = current_organization.catalog
  end

  def show
    @issued = DateTime.strptime(params[:id].to_s, '%s')
    @catalog = current_organization.catalog
  end
end
