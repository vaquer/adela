module ApplicationHelper
  def bootstrap_flash_class(key)
    case key
    when "notice" then "success"
    when "alert" then "danger"
    when "info" then "info"
    end
  end

  def step_image_class(show)
    unless show
      "hidden"
    end
  end

  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    #sentence = I18n.t('errors.messages.not_saved',
    #  count: resource.errors.count,
    #  resource: resource.class.model_name.human.downcase)
    sentence = "Corrige los siguientes errores:"

    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <h4>#{sentence}</h4>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  def header_step_image(step)
    if current_catalog.present? && step == 2 || current_organization.has_public_topics? && step == 1
      "step-checked"
    elsif step == 2
      "second-step"
    elsif step == 1
      "first-step"
    end
  end
end
