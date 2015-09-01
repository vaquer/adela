require 'spec_helper'

feature User, 'manages catalog:' do

  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees catalog link" do
    expect(page).to have_text("Plan de apertura")
    expect(page).to have_text("Catálogo de datos")
  end

  scenario "sees file input", :js => true do
    visit new_catalog_path
    find('#catalog_csv_file').should_not be_nil
  end

  scenario "succeed to upload a csv file" do
    visit new_catalog_path
    tries_to_upload_the_file('catalog.csv')
    expect(page).to have_text "2 conjuntos de datos y 7 recursos."
    sees_table_with_datasets
    activity_log_created_with_msg "actualizó su catálogo de datos."
  end

  scenario "fails to upload an invalid csv file" do
    visit new_catalog_path
    tries_to_upload_the_file('invalid_file.txt')
    sees_error_message "Vuelve a subir el archivo corrigiendo las filas incorrectas. Asegúrate de que sea en formato CSV y con las columnas como la plantilla en blanco que descargaste."
  end

  scenario "fails to upload a csv file with invalid structure" do
    visit new_catalog_path
    tries_to_upload_the_file('invalid_catalog.csv')
    sees_error_message "Vuelve a subir el archivo corrigiendo las filas incorrectas. Asegúrate de que sea en formato CSV y con las columnas como la plantilla en blanco que descargaste."
  end

  scenario "fails to upload an empty csv file" do
    visit new_catalog_path
    tries_to_upload_the_file('empty_catalog.csv')
    sees_error_message "Debe existir al menos un conjunto de datos en el archivo."
  end

  scenario "sees a preview of an incorrect uploaded file" do
    visit new_catalog_path
    tries_to_upload_the_file('invalid_catalog.csv')
    expect(page).to have_text("2 conjuntos de datos y 7 recursos.")
    sees_table_with_datasets
  end

  scenario "sees save action for uploaded valid csv file" do
    visit new_catalog_path
    tries_to_upload_the_file('catalog.csv')
    expect(page).to have_link "Guardar catálogo"
  end

  def tries_to_upload_the_file(file_name)
    attach_file('catalog_csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Subir catálogo")
  end

  def given_has_uploaded_an_catalog(days_ago)
    @catalog = FactoryGirl.create(:catalog)
    @catalog.update_attributes(:organization_id => @user.organization_id, :created_at => days_ago)
  end

  def sees_table_with_datasets
    within "table#datasets_preview" do
      expect(page).to have_text("Indicadores de pobreza")
      expect(page).to have_text("Índice de Rezago Social")
    end
  end
end
