class Admin::BaseController < ApplicationController
  layout 'application'

  before_action :authenticate_user!
  before_action :authorize_access
  before_action :set_admin_session
  before_action :check_admin_session

  private

  def set_admin_session
    unless session[:admin_logs_in]
      session[:admin_logs_in] = Time.now
    end
  end

  def authorize_access
    unless is_authorized?
      redirect_to root_path
    end
  end

  def is_authorized?
    session[:from_admin] || current_user.has_role?(:admin)
  end

  def check_admin_session
    if session[:admin_logs_in].present? && time_exceeded?
      expire_admin_session
    end
  end

  def time_exceeded?
    current_session_time = Time.now - session[:admin_logs_in].to_time
    current_session_time >= 900.seconds
  end

  def expire_admin_session
    session.delete(:admin_logs_in)
    sign_out(current_user)
    redirect_to user_session_es_path
  end
end
