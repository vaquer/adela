module DistributionsHelper
  def edit_link_to_text(distribution)
    distribution.published? ? 'Actualizar' : 'Completar'
  end
end
