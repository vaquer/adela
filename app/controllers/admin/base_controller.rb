class Admin::BaseController < ApplicationController
  layout 'application'

  before_action :authenticate_user!
  before_action :authorize_access
  before_action :set_admin_session
  before_action :check_admin_session

  def create_users
    uploader = UsersUploader.new
    uploader.store!(file_params)
    create_users_from_file(uploader.read)
    if @users.any?
      redirect_to admin_root_path, :notice => "Los usuarios se crearon exitosamente."
    else
      redirect_to admin_root_path, :alert => "Ocurrió un error al crear usuarios. Verificar archivo CSV."
    end
  end

  def users
    @users = User.created_at_sorted.paginate(:page => params[:page], :per_page => 30)
  end

  def organizations
    @organizations = Organization.includes(:users).title_sorted.paginate(:page => params[:page], :per_page => 30)
  end

  def acting_as
    @user = User.find(params[:user_id])

    session[:from_admin] = true
    sign_in(@user)

    redirect_to root_path
  end

  def stop_acting_as
    session[:from_admin] = false
    sign_out(current_user)

    redirect_to admin_root_path
  end

  private
  def set_admin_session
    unless session[:admin_logs_in]
      session[:admin_logs_in] = Time.now
    end
  end

  def authorize_access
    unless current_user.has_roles?([ :admin, :supervisor ])
      redirect_to root_path
    end
  end

  def file_params
    params.require(:csv_file)
  end

  def create_users_from_file(file_content)
    @users = []
    CSV.new(file_content.force_encoding('UTF-8'), :headers => :first_row).each do |row|
      organization = Organization.where(:title => row["organizacion"]).first_or_create
      password = Devise.friendly_token.first(8)
      user = User.new(name: row["nombre"], email: row["email"], password: password, password_confirmation: password, organization_id: organization.id)
      if user.save
        @users << user
        UserAccountWorker.perform_async(user.id, password)
      end
    end
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
    session[:admin_logs_in] = nil
    sign_out(current_user)
    redirect_to user_session_es_path
  end
end