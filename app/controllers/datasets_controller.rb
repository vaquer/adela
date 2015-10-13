class DatasetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @catalog = current_organization.catalog
  end
end
