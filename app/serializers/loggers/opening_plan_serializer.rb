class Loggers::OpeningPlanSerializer < ActiveModel::Serializer
  attributes *Dataset.column_names

  def attributes
    {
      title: title,
      description: description,
      accrual_periodicity: accrual_periodicity,
      publish_date: publish_date.strftime('%F')
    }
  end
end
