module DistributionsHelper
  def edit_link_to_text(distribution)
    distribution.broke? ? 'Completar' : 'Actualizar'
  end

  def options_for_media_type
    options_for_select(I18n.t('media_type'))
  end

  def state_description(distribution)
    case distribution.state
    when 'documented', 'refined'
      'Listo para publicar'
    when 'published'
      'Publicado'
    else
      'Falta información'
    end
  end
end
