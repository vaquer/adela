require 'spec_helper'

feature User, 'logs out:' do

  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees user home page" do
    expect(current_path).to eq(organization_path(@user.organization))
  end

  scenario "sees user name" do
    expect(page).to have_text(@user.name)
  end

  scenario "sees the log out link" do
    visit "/"
    expect(page).to have_text("Cerrar sesión")
  end

  scenario "succeed to log out" do
    visit "/"
    click_on("Cerrar sesión")
    sees_success_message "Usted ha salido del sistema."
  end

  def given_logged_in_as(user)
    visit "/users/sign_in"
    fill_in("Correo electrónico", :with => user.email)
    fill_in("Contraseña", :with => user.password)
    click_on("Entrar")
  end

  def sees_success_message(message)
    expect(page).to have_text(message)
    expect(page).to have_css(".alert-success")
  end
end
