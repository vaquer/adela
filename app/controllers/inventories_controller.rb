class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  rescue_from Exceptions::UnknownEncodingError, with: :unable_to_detect_encoding
  rescue_from CSV::MalformedCSVError, with: :malformed_csv

  def new
    @inventory = Inventory.new
  end

  def index
    @organization = current_organization
    @inventories = current_organization.inventories.date_sorted.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.organization_id = current_organization.id
    @inventory.author = current_user.name

    if @inventory.save
      record_activity("update", "actualizó su inventario de datos.")
    end

    @datasets = @inventory.datasets
    @upload_intent = true
    render :action => "new"
  end

  private

  def inventory_params
    params.require(:inventory).permit(:csv_file)
  end

  def unable_to_detect_encoding
    flash[:alert] = I18n.t("activerecord.errors.models.inventory.attributes.csv_file.encoding")
    redirect_to inventories_path
  end

  def malformed_csv
    flash[:alert] = I18n.t("activerecord.errors.models.inventory.attributes.csv_file.malformed")
    redirect_to inventories_path
  end
end
