require 'spec_helper'

feature User, 'updates inventory:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'and dataset metadata changes' do
    upload_inventory_with_file("inventory-issue-398.xlsx")
    generate_new_opening_plan
    inventory_dataset = @user.organization.catalog.distributions.sort.first

    visit edit_distribution_path(inventory_dataset)
    expect(download_url).to include "inventory-issue-398.xlsx"

    visit edit_dataset_path(inventory_dataset.dataset)
    expect(page).to have_content "irregular"

    visit new_inventory_path

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx")
    click_button "Subir inventario"
    InventoryXLSXParserWorker.new.perform(Inventory.last.id)

    visit edit_distribution_path(inventory_dataset)
    expect(download_url).to include "inventario_general_de_datos.xlsx"
    expect(download_url).not_to include "inventory-issue-398.xlsx"
    expect(modified_date).not_to be_blank
  end

  scenario 'and updates inventory dataset for publishing' do
    create :sector, title: "Custom sector"
    upload_inventory_with_file("inventory-issue-398.xlsx")
    generate_new_opening_plan

    click_link "Catálogo de Datos"

    within inventory_resource do
      expect(page).to have_content "Listo para publicar"
    end

    within inventory_set do
      expect(page).to have_content "Inventario Institucional de Datos"
      expect(page).to have_content "1 de 1"
      click_link "Editar"
    end

    fill_in "Correo del responsable", with: @user.email
    select "Custom sector", from: "dataset_dataset_sector_attributes_sector_id"

    click_link "Volver al catálogo"
    within inventory_set do
      expect(page).to have_content "Inventario Institucional de Datos"
      expect(page).to have_content "1 de 1"
    end

    within inventory_resource do
      expect(page).to have_content "Listo para publicar"
    end
  end

  scenario 'and sees new resources in catalog and can edit them' do
    skip
    upload_inventory_with_file("inventario_general_de_datos.xlsx")
    generate_new_opening_plan

    click_link "Catálogo de Datos"
    expect(page).to have_content "Tipos de vegetación"
    expect(page).to have_content "bosque de encinos, bosquie de coniferas, selva prenifolia, etc"
    expect(page).not_to have_content "Desierto"

    visit new_inventory_path

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos_update.xlsx")
    click_button "Subir inventario"
    InventoryXLSXParserWorker.new.perform(Inventory.last.id)

    generate_new_opening_plan
    click_link "Catálogo de Datos"

    expect(page).to have_content "Tipos de vegetación"
    expect(page).to have_content "bosque de encinos, bosquie de coniferas, selva prenifolia, etc"
    expect(page).to have_content "Desierto"

    within last_resource do
      expect(page).to have_content "Desierto"
      expect(page).to have_link "Completar"
      click_link "Completar"
    end

    expect(page).to have_field "URL para descargar"
    expect(page).to have_button "Guardar avance"
  end

  scenario 'and can not see removed resources from inventory' do
    skip
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

  scenario 'and sees catalog with consistent data' do
    skip
    upload_inventory_with_file("inventory-issue-398.xlsx")
    generate_new_opening_plan

    click_link "Catálogo de Datos"
    expect(page).to have_content "Servicios Personales"
    expect(page).not_to have_content "Tipos de vegetación"

    visit new_inventory_path

    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx")
    click_button "Subir inventario"
    InventoryXLSXParserWorker.new.perform(Inventory.last.id)
    generate_new_opening_plan

    click_link "Catálogo de Datos"
    expect(page).not_to have_content "Servicios Personales"
    expect(page).to have_content "Tipos de vegetación"
  end

  def no_duplicated_resources_on_catalog
    organization_distributions = @user.organization.catalog.distributions
    organization_distributions.map(&:title).uniq.size == organization_distributions.size
  end

  def no_duplicated_datasets_on_catalog
    organization_datasets = @user.organization.catalog.datasets
    organization_datasets.map(&:title).uniq.size == organization_datasets.size
  end

  def last_resource
    all("tr.distribution").last
  end

  def click_last_dataset_edit
    within last_resource do
      click_link "Editar"
    end
  end

  def download_url
    find("#distribution_download_url").value
  end

  def modified_date
    find("#distribution_modified").value
  end

  def inventory_set
    all("tr.dataset").first
  end

  def inventory_resource
    all("tr.distribution").first
  end

  def upload_inventory_with_file(file_name)
    spreadsheet_file = File.new("#{Rails.root}/spec/fixtures/files/#{file_name}")
    @inventory = create(:inventory, organization: @user.organization, spreadsheet_file: spreadsheet_file)
    InventoryXLSXParserWorker.new.perform(@inventory.id)
  end
end
