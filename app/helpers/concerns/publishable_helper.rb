module Concerns
  module PublishableHelper
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
