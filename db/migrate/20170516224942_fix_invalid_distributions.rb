class FixInvalidDistributions < ActiveRecord::Migration
  class Distribution < ActiveRecord::Base
    include Publishable
  end

  def change
    invalid_distributions = Distribution.select(&:invalid?)
    invalid_distributions.each do |distribution|
      organization = distribution.catalog.organization&.title
      next unless organization

      distribution.title = "#{distribution.title} de #{organization}"

      unless distribution.save
        created_at = distribution.created_at.strftime('%F %H:%M')
        distribution.title = "#{distribution.title} creado el #{created_at}"

        distribution.save
      end
    end
  end
end
