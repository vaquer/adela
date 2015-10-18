module DistributionsHelper
  def edit_link_to_text(distribution)
    distribution.published? ? 'Actualizar' : 'Completar'
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
