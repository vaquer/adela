module DistributionActions
  extend ActiveSupport::Concern

  def new
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.build
  end

  def create
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.create(distribution_params)
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
