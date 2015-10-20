require 'spec_helper'

feature User, 'sees inventory elements:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'when inventory file has been uploaded' do
    given_organization_with_catalog
    click_link 'Catálogo de Datos'

    within set_row do
      expect(page).to have_content "Inventario Institucional de Datos"
      expect(page).to have_content "28-Ago-2015"
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

  def given_organization_with_catalog
    upload_inventory_with_file("inventario_general_de_datos.xlsx")
    visit new_opening_plan_path
    fill_in 'organization_opening_plans_attributes_0_description', with: 'osom dataset'
    select('anual', from: 'organization[opening_plans_attributes][0][accrual_periodicity]')
    click_on('Generar Plan de Apertura')
  end
end
