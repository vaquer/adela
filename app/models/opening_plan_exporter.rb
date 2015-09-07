# encoding: UTF-8
class OpeningPlanExporter
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def export
    CSV.generate do |csv|
      csv << csv_headers
      @organization.opening_plans.each do |plan|
        csv << opening_plan_to_csv(plan)
      end
    end
  end

  private

  def csv_headers
    [
      'Visión institucional de datos abiertos',
      'Funcionario designado como Enlace',
      'Título del funcionario designado como Enlace',
      'Correo oficial del funcionario designado como Enalce',
      'Funcionario designado como Administrador',
      'Titulo del Funcionario designado como Administrador',
      'Correo oficial del funcioanrio designado como Administrador',
      'Conjuntos de datos priorizados',
      'Descripción de los conjuntos',
      'Periodicidad de la actualización',
      'Fecha tentativa de publicación (AAAA-MM-DD)'
    ]
  end

  def opening_plan_to_csv(opening_plan)
    [
      opening_plan.vision,
      liaison_official(opening_plan).try(:name),
      liaison_official(opening_plan).try(:position),
      liaison_official(opening_plan).try(:email),
      admin_official(opening_plan).try(:name),
      admin_official(opening_plan).try(:position),
      admin_official(opening_plan).try(:email),
      opening_plan.name,
      opening_plan.description,
      opening_plan.accrual_periodicity,
      opening_plan.publish_date
    ]
  end

  def liaison_official(opening_plan)
    opening_plan.officials.find(&:liaison?)
  end

  def admin_official(opening_plan)
    opening_plan.officials.find(&:admin?)
  end
end
