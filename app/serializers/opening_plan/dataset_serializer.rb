class OpeningPlan::DatasetSerializer < ActiveModel::Serializer
  attributes *Dataset.column_names

  def attributes
    {
      name: title,
      description: description,
      publish_date: publish_date.strftime('%F'),
      officials: [admin_official, liaison_official]
    }
  end

  def admin_official
    {
      type: 'Administrador de Datos',
      name: object.catalog.organization.administrator&.user&.name.to_s,
      email: object.catalog.organization.administrator&.user&.email.to_s,
    }
  end

  def liaison_official
    {
      type: 'Enlace Institucional',
      name: object.catalog.organization.liaison&.user&.name.to_s,
      email: object.catalog.organization.liaison&.user&.email.to_s,
    }
  end
end
