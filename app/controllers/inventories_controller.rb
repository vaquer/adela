class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.organization_id = current_organization.id
    @inventory.author = current_user.name

    if @inventory.save
      record_activity "actualizó su inventario de datos."
    end

    if @inventory.csv_right_encoding?
      @datasets = @inventory.datasets
    end
    @upload_intent = true
    render :action => "new"
  end

  def ignore_invalid_and_save
    temporary_path = "#{Rails.root}/tmp/inventory.csv"
    CsvProcessor.new(File.open(params[:csv_file]), current_organization).generate_csv(temporary_path)
    @inventory = Inventory.new(:csv_file => File.open(temporary_path))
    @inventory.organization_id = current_organization.id
    @inventory.author = current_user.name
    if @inventory.save
      record_activity "actualizó su inventario de datos."
      @datasets = @inventory.datasets
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(:csv_file)
  end
end
