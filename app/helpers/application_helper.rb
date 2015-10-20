module ApplicationHelper
  def home_path_helper
    if user_signed_in? && current_organization
      organization_path(current_organization)
    else
      root_path
    end
  end

  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = "Corrige los siguientes errores:"

    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <h4>#{sentence}</h4>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
