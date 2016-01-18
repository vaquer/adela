module DistributionActions
  def new
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.build
  end

  def create
    @dataset = Dataset.find(params['dataset_id'])
    @distribution = @dataset.distributions.create(distribution_params)
    create_customization if create_customization.present?
  end

  def edit
    @distribution = Distribution.find(params['id'])
  end

  def update
    @distribution = Distribution.find(params['id'])
    @distribution.update(distribution_params)
    update_customization if update_customization.present?
  end
end
