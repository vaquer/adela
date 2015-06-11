class DatasetsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if duplicated_identifiers?(value)
      record.errors[attribute] << I18n.t('activemodel.errors.models.data_set.attributes.identifier.duplicated')
    end
    if duplicated_titles?(value)
      record.errors[attribute] << I18n.t('activemodel.errors.models.data_set.attributes.title.duplicated')
    end
  end

  private

  def duplicated_titles?(datasets)
    duplicated_titles(datasets).present?
  end

  def duplicated_titles(datasets)
    titles = dataset_titles(datasets)
    titles.detect { |title| titles.count(title) > 1 }
  end

  def dataset_titles(datasets)
    datasets.map(&:title)
  end

  def duplicated_identifiers?(datasets)
    duplicated_identifiers(datasets).present?
  end

  def duplicated_identifiers(datasets)
    identifiers = dataset_identifiers(datasets)
    identifiers.detect { |identifier| identifiers.count(identifier) > 1 }
  end

  def dataset_identifiers(datasets)
    datasets.map(&:identifier)
  end
end
