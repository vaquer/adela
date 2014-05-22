class InventoriesController < ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def new
    @inventory = current_user.inventories.unpublished.first
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.organization_id = current_organization.id
    @inventory.author = current_user.name
    @inventory.save

    if @inventory.csv_right_encoding?
      @datasets = @inventory.datasets
    end
    @upload_intent = true
    render :action => "new"
  end

  def publish
  end

  def ignore_invalid_and_save
    @temporary_path = "#{Rails.root}/tmp/inventory.csv"
    generate_csv
    @inventory = Inventory.new(:csv_file => File.open(@temporary_path))
    @inventory.organization_id = current_organization.id
    @inventory.author = current_user.name
    @inventory.save
    @datasets = @inventory.datasets
    @upload_intent = true
    render :action => "new"
  end

  private

  def inventory_params
    params.require(:inventory).permit(:csv_file)
  end

  def generate_csv
    File.open(@temporary_path, "w") do |csv|
      csv << [:title, :description, :keyword, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :accessURL, :format, :license, :spatial, :temporal].to_csv
      CSV.foreach(File.open(params[:csv_file]), :headers => :first_row).each do |dataset|
        dataset_obj = DataSet.new({
          :title => dataset["title"],
          :description => dataset["description"],
          :keyword => dataset["keyword"],
          :modified => dataset["modified"],
          :publisher => dataset["publisher"],
          :contactPoint => dataset["contactPoint"],
          :mbox => dataset["mbox"],
          :identifier => dataset["identifier"],
          :accessLevel => dataset["accessLevel"],
          :accessLevelComment => dataset["accessLevelComment"],
          :accessUrl => dataset["accessURL"],
          :format => dataset["format"],
          :license => dataset["license"],
          :spatial => dataset["spatial"],
          :temporal => dataset["temporal"]
        })
        csv << dataset_obj.values_array.to_csv if dataset_obj.valid?
      end
    end
  end
end
