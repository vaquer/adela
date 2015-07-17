class OrganizationOpeningPlanSerializer < ActiveModel::Serializer
  has_many :opening_plans, each_serializer: OpeningPlanSerializer

  def attributes
    data ||= {}
    data[:title] = "Plan de Apertura de #{object.title}"
    data[:language] = "es"
    data[:license] = "http://datos.gob.mx/libreusomx/"
    data.merge super
  end
end
