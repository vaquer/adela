module CatalogsHelper
  def can_publish?(catalog)
    catalog.datasets.map(&:distributions).flatten.map(&:state).grep('validated').present?
  end
end
