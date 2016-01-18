module DatasetActions
  def create
    @dataset = current_organization.catalog.datasets.create(dataset_params)
    create_customization if create_customization.present?
  end

  def edit
    @dataset = Dataset.find(params['id'])
  end

  def update
    @dataset = Dataset.find(params['id'])
    @dataset.update(dataset_params)
    update_customization if update_customization.present?
  end

  def destroy
    @dataset = Dataset.find(params['id'])
    @dataset.destroy
    destroy_customization if destroy_customization.present?
  end
end
