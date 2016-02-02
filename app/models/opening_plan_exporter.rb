# encoding: UTF-8
class OpeningPlanExporter
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def export
    CSV.generate do |csv|
      csv << csv_headers
      @organization.catalog.datasets.where(public_access: true, published: true, editable: true).each do |dataset|
        csv << opening_plan_row(dataset)
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

  def opening_plan_row(dataset)
    [
      nil, # TODO: issue #753 mxabierto/adela
      liaison_official&.name,
      nil, # TODO: issue #754 mxabierto/adela
      liaison_official&.email,
      admin_official&.name,
      nil, # TODO: issue #755 mxabierto/adela
      admin_official&.email,
      dataset.title,
      dataset.description,
      dataset.accrual_periodicity,
      dataset.publish_date
    ]
  end

  def liaison_official
    @organization.liaison&.user
  end

  def admin_official
    @organization.administrator&.user
  end
end
