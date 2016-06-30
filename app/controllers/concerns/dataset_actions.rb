module DatasetActions
  extend ActiveSupport::Concern

  included do
    before_action :create_catalog, only: :create
  end

  def create
    @dataset = current_organization.catalog.datasets.create(dataset_params)
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

  private

  def create_catalog
    current_organization.create_catalog unless current_organization.catalog
  end
end
