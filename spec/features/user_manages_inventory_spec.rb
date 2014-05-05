require 'spec_helper'

feature User, 'manages inventory:' do
  
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees inventory link" do
    expect(page).to have_text("Plan de apertura")
    expect(page).to have_link("Inventario de datos")
  end

  scenario "sees file input", :js => true do
    visit new_inventory_path
    click_on("Carga el inventario")
    click_on("Actualizar inventario")
    find('#inventory_file_location').should_not be_nil
  end

  scenario "succeed to upload a csv file" do
    visit new_inventory_path
    click_on("Carga el inventario")
    click_on("Actualizar inventario")
    tries_to_upload_the_file('inventory.csv')
    sees_success_message "El archivo se ha cargado exitosamente."
  end

  scenario "fails to upload an invalid csv file" do
    visit new_inventory_path
    click_on("Carga el inventario")
    click_on("Actualizar inventario")
    tries_to_upload_the_file('invalid_inventory.csv')
    sees_error_message "Ha ocurrido un error. El archivo no es válido."
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

  def sees_error_message(message)
    expect(page).to have_text(message)
    expect(page).to have_css(".alert-danger")
  end

  def tries_to_upload_the_file(file_name)
    attach_file('inventory_file_location', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Guardar")
  end
end