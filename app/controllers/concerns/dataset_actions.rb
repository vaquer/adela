module DatasetActions
  extend ActiveSupport::Concern

  included do
    load_and_authorize_resource except: [:new, :create]
    before_action :create_catalog, only: :create
    helper_method :sort_column, :sort_direction
  end

  def index
    @datasets = current_organization.catalog.datasets
    index_customization if self.class.private_method_defined? :index_customization
  end

  def new
    @dataset = Dataset.new
    @dataset.catalog = current_organization.catalog
    authorize! :new, @dataset
    new_customization if self.class.private_method_defined? :new_customization
  end

  def create
    @dataset = current_organization.catalog.datasets.build(dataset_params)
    authorize! :create, @dataset
    @dataset.save
    create_customization if self.class.private_method_defined? :create_customization
  end

  def edit
    @dataset = Dataset.find(params['id'])
    edit_customization if self.class.private_method_defined? :edit_customization
  end

  def update
    @dataset = Dataset.find(params['id'])
    @dataset.update(dataset_params)
    update_customization if self.class.private_method_defined? :update_customization
  end

  def destroy
    @dataset = Dataset.find(params['id'])
    @dataset.destroy
    destroy_customization if self.class.private_method_defined? :destroy_customization
  end

  def sort_column
    Dataset.column_names.include?(params[:sort]) ? params[:sort] : 'publish_date'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  private

  def create_catalog
    current_organization.create_catalog unless current_organization.catalog
  end
end
