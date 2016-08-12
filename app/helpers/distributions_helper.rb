module DistributionsHelper
  def options_for_media_type
    options_for_select(I18n.t('media_type'))
  end
end
