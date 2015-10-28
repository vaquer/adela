require 'spec_helper'

feature User, 'updates inventory:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'and sees warning message' do
    pending
    upload_inventory_with_file("inventario_general_de_datos.xlsx")

    click_link 'Inventario de Datos'
    expect(page).to have_content "Tipos de vegetación"
    expect(page).to have_content "Montos Programa Adultos Mayores"
    expect(page).to have_content "Peticiones de los ciudadanos"

    click_link 'Actualizar Inventario'

    expect(page).to have_content "Si renombras un conjunto o recurso se eliminará lo que se tenga actualmente y aparecerá como uno nuevo."
    expect(page).to have_content "Si eliminas un conjunto o recurso se eliminará del catálogo permanentemente."
    expect(page).to have_field "Mensaje"

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventory-issue-398.xlsx")
    fill_in "Mensaje", with: "Commit message"
    click_button "Subir inventario"

    InventoryXLSXParserWorker.new.perform(Inventory.last.id)
    visit inventory_path(Inventory.last)

    expect(page).not_to have_content "Tipos de vegetación"
    expect(page).not_to have_content "Montos Programa Adultos Mayores"
    expect(page).not_to have_content "Peticiones de los ciudadanos"
    expect(page).to have_content "Servicios Personales"
  end

  scenario 'and generates new opening plan and catalog' do
    upload_inventory_with_file("inventory-issue-398.xlsx")

    visit new_opening_plan_path
    expect(first_set).to include "Servicios Personales"
    expect(first_set).not_to include "Tipos de vegetación"

    visit new_inventory_path

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx")
    click_button "Subir inventario"
    InventoryXLSXParserWorker.new.perform(Inventory.last.id)

    visit new_opening_plan_path
    expect(first_set).not_to include "Servicios Personales"
    expect(first_set).to include "Tipos de vegetación"
  end

  scenario 'and can not see removed resources from inventory' do
    upload_inventory_with_file("inventario_general_de_datos_update.xlsx")
    generate_new_opening_plan

    click_link "Catálogo de Datos"
    expect(page).to have_content "Tipos de vegetación"
    expect(page).to have_content "bosque de encinos, bosquie de coniferas, selva prenifolia, etc"
    expect(page).to have_content "Desierto"

    visit new_inventory_path

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx")
    click_button "Subir inventario"
    InventoryXLSXParserWorker.new.perform(Inventory.last.id)
    @user.organization.reload
    generate_new_opening_plan

    click_link "Catálogo de Datos"
    expect(page).to have_content "Tipos de vegetación"
    expect(page).to have_content "bosque de encinos, bosquie de coniferas, selva prenifolia, etc"
    expect(page).not_to have_content "Desierto"
  end

  def first_set
    find_field("organization_opening_plans_attributes_0_name").value
  end

  def upload_inventory_with_file(file_name)
    spreadsheet_file = File.new("#{Rails.root}/spec/fixtures/files/#{file_name}")
    @inventory = create(:inventory, organization: @user.organization, spreadsheet_file: spreadsheet_file)
    InventoryXLSXParserWorker.new.perform(@inventory.id)
  end
end
