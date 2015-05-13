class DatasetsTitlesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
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
end
