require 'spec_helper'

feature User, 'sees inventory elements:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'when inventory file has been uploaded' do
    create :sector, title: "Custom sector"
    given_organization_with_ready_catalog
    click_link 'Catálogo de Datos'

    within set_row do
      expect(page).to have_content "Inventario Institucional de Datos"
      expect(page).to have_content "28-Ago-15"
      expect(page).to have_content "1 de 1"
      expect(page).to have_link "Editar"
    end

    within resource_row do
      expect(resource_checkbox).to be_checked
      expect(page).to have_content "Listo para publicar"
      expect(page).to have_link "Actualizar"
    end
  end

  def resource_checkbox
    find("input[type='checkbox']")
  end

  def set_row
    all('table tbody tr')[0]
  end

  def resource_row
    all('table tbody tr')[1]
  end

  def upload_inventory_with_file(file_name)
    spreadsheet_file = File.new("#{Rails.root}/spec/fixtures/files/#{file_name}")
    @inventory = create(:inventory, organization: @user.organization, spreadsheet_file: spreadsheet_file)
    InventoryXLSXParserWorker.new.perform(@inventory.id)
  end

  def generate_new_opening_plan
    visit new_opening_plan_path
    fill_in 'organization_opening_plans_attributes_0_description', with: 'osom dataset'
    select('anual', from: 'organization[opening_plans_attributes][0][accrual_periodicity]')
    click_on('Generar Plan de Apertura')
  end

  def edit_catalog_first_set
    click_link "Catálogo de Datos"
    within set_row do
      click_link "Editar"
    end

    fill_in "Correo del responsable", with: @user.email
    select "Custom sector", from: "dataset_dataset_sector_attributes_sector_id"
    click_link "Volver al catálogo"
  end

  def complete_first_resource_set
    click_link "Catálogo de Datos"
    within resource_row do
      click_link "Completar"
    end
    fill_in "URL para descargar", with: "http://www.fakeurl.com"
    fill_in "init-date", with: "2015"
    fill_in "term-date", with: "2015-12-20"
    fill_in "distribution_modified", with: "2015-08-28"
    click_button "Guardar avance"
    click_link "Volver al catálogo"
  end

  def given_organization_with_ready_catalog
    upload_inventory_with_file("inventario_general_de_datos.xlsx")
    generate_new_opening_plan
    edit_catalog_first_set
    complete_first_resource_set
  end
end
