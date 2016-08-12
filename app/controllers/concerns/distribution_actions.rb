module DistributionActions
  extend ActiveSupport::Concern

  included do
    load_and_authorize_resource except: [:new, :create]
  end

  def new
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.build
    authorize! :new, @distribution
  end

  def create
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.build(distribution_params)
    authorize! :create, @distribution
    @distribution.save
    create_customization if self.class.private_method_defined? :create_customization
  end

  def edit
    @distribution = Distribution.find(params['id'])
  end

  def update
    @distribution = Distribution.find(params['id'])
    @distribution.update(distribution_params)
    update_customization if self.class.private_method_defined? :update_customization
  end

  def destroy
    @distribution = Distribution.find(params['id'])
    @distribution.destroy
    destroy_customization if self.class.private_method_defined? :destroy_customization
  end
end
