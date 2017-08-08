module DatasetsHelper
  def accrual_periodicity_translate(accrual_periodicity)
    ISO8601_DEFAULTS['accrual_periodicity'].invert[accrual_periodicity]
  end

  def published_distributions?(dataset)
    dataset.distributions.select(&:published?).present?
  end

  def documented_distributions(dataset)
    dataset.distributions.reject { |distribution| distribution.refining? || distribution.broke? }
  end

  def sector_title(dataset)
    dataset.sector.present? ? dataset.sector.title : 'Sector no definido'
  end
end
