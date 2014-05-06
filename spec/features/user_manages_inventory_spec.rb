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
    find('#inventory_csv_file').should_not be_nil
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
    tries_to_upload_the_file('invalid_file.txt')
    sees_error_message "Archivo no es válido. Debe estar en formato .csv"
  end

  scenario "fails to upload a csv file with invalid structure" do
    visit new_inventory_path
    click_on("Carga el inventario")
    click_on("Actualizar inventario")
    tries_to_upload_the_file('invalid_inventory.csv')
    sees_error_message "Registro 1: Accessurl no puede estar en blanco si la base de datos es Pública."
    sees_error_message "Registro 2: Keyword no puede estar en blanco"
    sees_error_message "Registro 2: Accesslevelcomment no puede estar en blanco si la base de datos es Privada o Restringida."
  end

  scenario "sees a preview of the uploaded file" do
    given_has_uploaded_an_inventory(12.days.ago)
    visit new_inventory_path
    expect(page).to have_text("actualizado por última vez hace 12 días")
    sees_table_with_datasets
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
    attach_file('inventory_csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Guardar")
  end

  def given_has_uploaded_an_inventory(days_ago)
    @inventory = FactoryGirl.create(:inventory)
    @inventory.update_attributes(:organization_id => @user.organization_id, :created_at => days_ago)
  end

  def sees_table_with_datasets
    expect(page).to have_css("table#datasets_preview")
    expect(page).to have_text("Presupuesto de egresos 2013")
    expect(page).to have_text("Recetas médicas de Octubre")
  end
end