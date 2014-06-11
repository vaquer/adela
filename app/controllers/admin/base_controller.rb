class Admin::BaseController < ApplicationController
  layout 'application'
  http_basic_authenticate_with name: ENV['ADMIN_AUTH_NAME'], password: ENV['ADMIN_AUTH_PASSWORD'] unless Rails.env.test?

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

  private

  def file_params
    params.require(:csv_file)
  end

  def create_users_from_file(file_content)
    @users = []
    CSV.new(file_content.force_encoding('UTF-8'), :headers => :first_row).each do |row|
      organization = Organization.where(:title => row["organizacion"]).first_or_create
      password = Devise.friendly_token.first(8)
      user = User.create(name: row["nombre"], email: row["email"], password: password, password_confirmation: password, organization_id: organization.id)
      if user
        @users << user
        UserMailer.notificate_user_account(user, password)
      end
    end
  end
end