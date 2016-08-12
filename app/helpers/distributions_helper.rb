module DistributionsHelper
  def edit_link_to_text(distribution)
    distribution.broke? ? 'Completar' : 'Actualizar'
  end

  def options_for_media_type
    options_for_select(I18n.t('media_type').invert)
  end

  def state_description(distribution)
    if distribution.broke?
      'Falta información'
    elsif distribution.documented?
      'Listo para publicar'
    else
      'Publicado'
    end
  end
end
