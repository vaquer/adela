require 'spec_helper'

feature User, 'logs in:' do
  
  background do
    @user = FactoryGirl.create(:user)
  end

  scenario "fails to access a protected page" do
    visit "/users/#{@user.id}/"

    sees_error_message "Necesita ingresar o registrarse para continuar."
  end

  scenario "visits root page and sees landing page" do
    visit "/"
    pending "Missing landing page"
  end

  scenario "visits root page and sees log in link" do
    visit "/"
    expect(page).to have_text("Iniciar sesión")
  end

  scenario "sees the log in form" do
    visit "/"
    click_link("Iniciar sesión")
    sees_signin_form
  end

  scenario "fails to log in with an invalid account" do
    visit "/users/sign_in"
    fill_the_form_with(@user.email, "wrong_password")
    click_on("Entrar")
    sees_error_message "Correo o contraseña inválidos."
  end

  scenario "succeed to log in with a valid account" do
    visit "/users/sign_in"
    fill_the_form_with(@user.email, @user.password)
    click_on("Entrar")
    sees_success_message "Ingreso exitoso."
    expect(current_path).to eq(user_path(@user.id))
  end

  def sees_error_message(message)
    expect(page).to have_text(message)
    expect(page).to have_css(".alert-danger")
  end

  def sees_success_message(message)
    expect(page).to have_text(message)
    expect(page).to have_css(".alert-success")
  end

  def sees_signin_form
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_css("#user_email")
    expect(page).to have_css("#user_password")
  end

  def fill_the_form_with(email, password)
    fill_in("Correo electrónico", :with => email)
    fill_in("Contraseña", :with => password)
  end
end