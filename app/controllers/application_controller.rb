class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_organization

  def after_sign_in_path_for(resource)
    organization_path(current_organization)
  end

  def current_organization
    current_user && current_user.organization
  end

  def record_activity(category, description)
    if current_organization.present?
      @activity = ActivityLog.new(:category => category, :description => description, :organization_id => current_organization.id, :done_at => DateTime.now)
      @activity.save
    end
  end
end
