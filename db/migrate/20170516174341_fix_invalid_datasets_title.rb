class FixInvalidDatasetsTitle < ActiveRecord::Migration
  def change
    invalid_datasets = Dataset.select(&:invalid?).select do |dataset|
      dataset.errors.messages.has_key?(:title)
    end

    invalid_datasets.each do |dataset|
      organization = dataset.catalog.organization.title
      dataset.title = "#{dataset.title} de #{organization}"

      unless dataset.save
        created_at = dataset.created_at.strftime('%F %H:%M')
        dataset.title = "#{dataset.title} creado el #{created_at}"

        dataset.save
      end
    end
  end
end
