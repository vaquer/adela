module DatasetsHelper
  def published_distributions_percentage(dataset)
    total = dataset.distributions.count
    published = dataset.distributions.where(published: true).count
    (published.to_f / total * 100).to_i
  rescue
    0
  end

  def accrual_periodicity_translate(accrual_periodicity)
    ISO8601_DEFAULTS['accrual_periodicity'].invert[accrual_periodicity]
  end
end
