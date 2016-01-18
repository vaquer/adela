module DatasetsHelper
  def accrual_periodicity_translate(accrual_periodicity)
    ISO8601_DEFAULTS['accrual_periodicity'].invert[accrual_periodicity]
  end

  def published_distributions?(dataset)
    dataset.distributions.select(&:published?).present?
  end

  def documented_distributions(dataset)
    dataset.distributions.select { |d| d.published? || d.documented? }
  end

  def next_dataset(dataset)
    datasets = current_organization.catalog.datasets.where(published: true).sort_by(&:publish_date)
    index = datasets.index { |ds| ds.id == dataset.id }
    datasets[index + 1]
  end

  def sector_title(dataset)
    dataset.sector.present? ? dataset.sector.title : 'Sector no definido'
  end
end
