class OpeningPlanSerializer < ActiveModel::Serializer
  has_many :opening_plans, serializer: OpeningPlan::DatasetSerializer

  def attributes
    {
      title: "Plan de Apertura de #{object.catalog.organization.title}",
      language: 'es',
      license: 'http://datos.gob.mx/libreusomx/',
    }
  end

  def opening_plans
    object.catalog.opening_plan_datasets
  end
end
