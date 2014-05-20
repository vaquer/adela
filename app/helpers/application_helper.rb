module ApplicationHelper
  def bootstrap_flash_class(key)
    case key
    when "notice" then "success"
    when "alert" then "danger"
    when "info" then "info"
    end
  end
end
