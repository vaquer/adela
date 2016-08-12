module Concerns
  module PublishableHelper
    def can_publish?(catalog)
      can_publish_datasets?(catalog) || can_publish_distributions?(catalog)
    end

    def can_publish_datasets?(catalog)
      catalog.datasets.where('datasets.state = \'documented\' OR datasets.state = \'refined\'').present?
    end

    def can_publish_distributions?(catalog)
      catalog.distributions.where('distributions.state = \'documented\' OR distributions.state = \'refined\'').present?
    end

    def state_description(resource)
      case resource.state
      when 'documented', 'refined'
        'Listo para publicar'
      when 'published'
        'Publicado'
      else
        'Falta información'
      end
    end
  end
end
