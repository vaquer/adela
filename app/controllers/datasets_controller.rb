class DatasetsController < ApplicationController
  def index
    @catalog = current_organization.catalog
  end
end
