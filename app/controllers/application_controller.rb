class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_organization

  def after_sign_in_path_for(resource)
    if current_organization.inventories.any?
      organization_path(current_user.organization)
    elsif current_organization.topics.any?
      new_inventory_path
    else
      topics_path
    end
  end

  def current_organization
    current_user && current_user.organization
  end
end
