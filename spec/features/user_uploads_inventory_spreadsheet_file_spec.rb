require 'spec_helper'

feature User, 'uploads inventory spreadsheet file:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'a valid spreadsheet file' do
    within('.navbar') { click_on('Inventario de Datos') }
    submit_inventory_form_with_spreadsheet_file('inventario_general_de_datos.xlsx')

    expect(page).to have_css('.table tbody tr.dataset', count: 3)
    expect(page).to have_css('.table tbody tr.distribution', count: 3)

    within find('tr.dataset', text: 'Tipos de vegetación') do
      expect(page).to have_text('Público')
      expect(page).to have_text('2099-06-01')
      expect(page).to have_css('.dropdown')
    end

    within find('tr.distribution', text: 'bosque de encinos, bosquie de coniferas, selva prenifolia, etc.') do
      expect(page).to have_text('excel')
      expect(page).to have_css('.dropdown')
    end

    within find('tr.dataset', text: 'Montos Programa Adultos Mayores') do
      expect(page).to have_text('Privado')
      expect(page).to have_css('.dropdown')
    end

    within find('tr.distribution', text: 'Montos Programa Adultos Mayores') do
      expect(page).to have_text('excel')
      expect(page).to have_css('.dropdown')
    end

    within find('tr.dataset', text: 'Peticiones de los ciudadanos') do
      expect(page).to have_text('Privado')
      expect(page).to have_css('.dropdown')
    end

    within find('tr.distribution', text: 'respondidas, pendientes, no procedentes, etc') do
      expect(page).to have_text('oracle')
      expect(page).to have_css('.dropdown')
    end
  end

  scenario 'a valid spreadsheet file with authorization file' do
    within('.navbar') { click_on('Inventario de Datos') }
    submit_inventory_form_with_spreadsheet_and_autorization_files('inventario_general_de_datos.xlsx')

    expect(page).to have_css('.table tbody tr.dataset', count: 3)
    expect(page).to have_css('.table tbody tr.distribution', count: 3)
  end

  scenario 'another spreadsheet file with a new dataset', js: true do
    upload_inventory_with_file('inventario_general_de_datos.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within('.btn-group') do
      click_on('Acciones')
      click_on('Actualizar')
    end

    expect(current_path).to eq(new_inventory_path)
    submit_inventory_form_with_spreadsheet_file('another-inventory-spreadsheet-file.xlsx')

    expect(page).to have_css('.table tbody tr.dataset', count: 4)
    expect(page).to have_css('.table tbody tr.distribution', count: 4)

    within find('tr.dataset', text: 'Mantenimiento Portuario') do
      expect(page).to have_text('Público')
    end

    within find('tr.distribution', text: 'Programa anual de Mantenimiento') do
      expect(page).to have_text('Excel')
    end
  end

  scenario 'another spreadsheet file with a new resource', js: true do
    upload_inventory_with_file('inventario_general_de_datos.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within('.btn-group') do
      click_on('Acciones')
      click_on('Actualizar')
    end

    expect(current_path).to eq(new_inventory_path)
    submit_inventory_form_with_spreadsheet_file('inventario_general_de_datos_update.xlsx')

    expect(page).to have_css('.table tbody tr.dataset', count: 3)
    expect(page).to have_css('.table tbody tr.distribution', count: 4)

    within find('tr.dataset', text: 'Tipos de vegetación') do
      expect(page).to have_text('Público')
      expect(page).to have_text('2099-06-01')
    end

    within find('tr.distribution', text: 'bosque de encinos, bosquie de coniferas, selva prenifolia, etc.') do
      expect(page).to have_text('excel')
    end

    within find('tr.distribution', text: 'Desierto') do
      expect(page).to have_text('excel')
    end
  end

  def submit_inventory_form_with_spreadsheet_file(file_name)
    attach_inventory_spreadsheet_file(file_name)
    fill_activity_log
    submit_inventory_form_and_run_background_jobs
  end

  def submit_inventory_form_with_spreadsheet_and_autorization_files(file_name)
    attach_inventory_spreadsheet_file(file_name)
    attach_inventory_authorization_file
    submit_inventory_form_and_run_background_jobs
  end

  def attach_inventory_spreadsheet_file(file_name)
    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
  end

  def attach_inventory_authorization_file
    attach_file('inventory_authorization_file', "#{Rails.root}/spec/fixtures/files/authorization_file.jpg")
  end

  def fill_activity_log
    return unless page.has_css?('#inventory_activity_logs_attributes_0_description')
    fill_in('inventory_activity_logs_attributes_0_description', with: Faker::Lorem.paragraph)
  end

  def submit_inventory_form_and_run_background_jobs
    click_on('Subir inventario')
    InventoryDatasetsWorker.new.perform(Inventory.last.id)
    visit inventories_path
  end
end
