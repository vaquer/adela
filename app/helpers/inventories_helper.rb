module InventoriesHelper
  def preview_dataset_class(dataset)
    unless dataset.valid?
      "danger"
    end
  end

  def display_datasets_preview?(datasets)
    datasets.present? || current_inventory.present?
  end

  def current_inventory
    @current_inventory ||= current_user.inventories.date_sorted.first
  end

  def datasets_to_display(datasets)
    if datasets.present?
      datasets
    else
      current_inventory.datasets
    end
  end
end