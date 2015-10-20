module DistributionsHelper
  def edit_link_to_text(distribution)
    distribution.broke? ? 'Completar' : 'Actualizar'
  end

  def state_description(distribution)
    if distribution.broke?
      'Falta información'
    elsif distribution.validated?
      'Listo para publicar'
    else
      'Publicado'
    end
  end
end
