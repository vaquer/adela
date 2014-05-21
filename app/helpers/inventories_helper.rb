module InventoriesHelper
  def preview_dataset_class(dataset)
    unless dataset.valid?
      "danger"
    end
  end

  def current_inventory
    @current_inventory ||= current_user.inventories.unpublished.first
  end

  def current_catalog
    @current_catalog ||= current_user.inventories.published.first
  end

  def datasets_to_display(datasets)
    if datasets.present?
      datasets
    elsif current_inventory.present?
      current_inventory.datasets
    end
  end

  def invalid_datasets?(inventory)
    inventory.datasets.present? && !inventory.csv_structure_valid?
  end

  def file_structure_feedback(datasets)
    invalid_datasets_count = datasets.map(&:valid?).count(false)
    valid_datasets_count = datasets.map(&:valid?).count(true)
    "#{valid_datasets_count} sets de datos completos y #{invalid_datasets_count} sets de datos incompletos."
  end

  def display_publish_form?(from_dashboard)
    unless from_dashboard
      "hidden"
    end
  end

  def inventory_history(inventory)
    "Fecha de captura: #{I18n.l(inventory.created_at, :format => :short)}, por #{inventory.author}."
  end
end