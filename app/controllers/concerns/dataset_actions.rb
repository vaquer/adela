module DatasetActions
  def edit
    @dataset = Dataset.find(params['id'])
  end

  def update
    @dataset = Dataset.find(params['id'])
    @dataset.update(dataset_params)
    update_customization if update_customization.present?
  end
end
