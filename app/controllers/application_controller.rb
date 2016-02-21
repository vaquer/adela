class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_organization
  helper_method :current_inventory

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => I18n.t("errors.messages.access_denied")
  end

  def after_sign_in_path_for(resource)
    current_organization ? organization_path(current_organization) : root_path
  end

  def current_organization
    current_user && current_user.organization
  end

  def current_inventory
    current_organization && current_organization.inventories.order(created_at: :desc).find(&:valid?)
  end

  def set_locale
    I18n.locale = :es
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
