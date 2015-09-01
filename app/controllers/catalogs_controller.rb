class CatalogsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  layout 'home'

  rescue_from Exceptions::UnknownEncodingError, with: :unable_to_detect_encoding
  rescue_from CSV::MalformedCSVError, with: :malformed_csv

  def new
    @catalogs = Catalog.new
  end

  def index
    @organization = current_organization
    @catalogs = current_organization.catalogs.date_sorted.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    @catalog = Catalog.new(catalog_params)
    @catalog.organization_id = current_organization.id
    @catalog.author = current_user.name

    if @catalog.save
      record_activity("update", "actualizó su catálogo de datos.")
    end

    @datasets = @catalog.datasets
    @upload_intent = true
    render :action => "new"
  end

  private

  def catalog_params
    params.require(:catalog).permit(:csv_file)
  end

  def unable_to_detect_encoding
    flash[:alert] = I18n.t("activerecord.errors.models.catalog.attributes.csv_file.encoding")
    redirect_to catalogs_path
  end

  def malformed_csv
    flash[:alert] = I18n.t("activerecord.errors.models.catalog.attributes.csv_file.malformed")
    redirect_to catalogs_path
  end
end
