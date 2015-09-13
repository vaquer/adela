module CatalogsHelper
  def preview_dataset_class(dataset)
    unless dataset.valid?
      "danger"
    end
  end

  def unpublished_catalog
    @unpublished_catalog ||= current_user.catalogs.unpublished.first
  end

  def current_catalog
    @current_catalog ||= current_user.catalogs.published.first
  end

  def datasets_to_display(datasets)
    if datasets.present?
      datasets
    elsif unpublished_catalog.present?
      unpublished_catalog.datasets
    end
  end

  def invalid_datasets?(catalog)
    catalog.datasets.present? && !catalog.csv_structure_valid?
  end

  def file_structure_feedback(datasets)
    distributions_count = datasets.map(&:distributions_count).compact.sum
    "Se detectaron #{I18n.t("plural.datasets", :count => datasets.size)} y #{I18n.t("plural.distributions", :count => distributions_count)}."
 end

  def display_publish_form?(from_dashboard)
    unless from_dashboard
      "hidden"
    end
  end

  def catalog_history(catalog)
    "Fecha de captura: #{I18n.l(catalog.created_at, :format => :short)}, por #{catalog.author}."
  end
end
