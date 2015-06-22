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

  def last_activity(organization)
    if activity_at = organization.last_activity_at
      "Hace #{time_ago_in_words(activity_at)}"
    else
      "Sin actividad"
    end
  end

  def activity_months_range(organization)
    if organization.present?
      months = OpeningPlan.publish_date_sorted.where("opening_plans.organization_id = #{organization}").month_range
    else
      months = OpeningPlan.publish_date_sorted.month_range
    end
  end

  def previous_month(current, organization = nil)
    current_index = activity_months_range(organization).index(current)
    if current_index && current_index > 0
      activity_months_range(organization)[current_index - 1]
    elsif !current_index || current_index.zero?
      OpeningPlan.previous_month_with_topics(current, organization)
    else
      ""
    end
  end

  def next_month(current, organization = nil)
    current_index = activity_months_range(organization).index(current)
    if current_index && current_index <= (activity_months_range(organization).size - 1)
      activity_months_range(organization)[current_index + 1]
    elsif !current_index || current_index == (activity_months_range(organization).size - 1)
      OpeningPlan.next_month_with_topics(current, organization)
    else
      ""
    end
  end

  def activity_years_range(organization = nil)
    if organization.present?
      months = OpeningPlan.where("opening_plans.organization_id = #{organization}").year_range
    else
      months = OpeningPlan.year_range
    end
  end

  def calendar_button_class(current_month, year)
    if current_month.to_date.strftime("%Y") == year.to_date.strftime("%Y")
      "active"
    end
  end

  def gov_link(organization)
    "#{ENV['CATALOG_URL']}#{organization.slug}"
  end
end
