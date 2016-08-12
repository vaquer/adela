require 'spec_helper'

feature User, 'manages catalog:' do
  background do
    @user = create(:user)
    given_logged_in_as(@user)
  end

  scenario 'clicks opening plan link' do
    within '.nav.navbar-nav.navbar-right' do
      expect(page).to have_text('Plan de Apertura')
      click_on('Plan de Apertura')
      expect(current_path).to eq(opening_plans_path)
    end
  end

  scenario 'visits new opening plan link with out an inventory' do
    visit new_opening_plan_path
    within '.card.padding-top.bg--grey' do
      expect(page).to have_text('Antes de generar el Plan de apertura de la institución debes de subir el Inventario de Datos.')
      click_on('Subir')
      expect(current_path).to eq(new_inventory_path)
    end
  end

  scenario 'generates new opening plan' do
    inventory = create(:inventory, organization: @user.organization)
    InventoryXLSXParser.new(inventory).parse
    visit new_opening_plan_path
    fill_in 'catalog_datasets_attributes_0_description', with: 'osom dataset'
    select('anual', from: 'organization[opening_plans_attributes][0][accrual_periodicity]')
    click_on('Guardar Plan de Apertura')
    expect(page).to have_text('osom dataset')
    expect(page).to have_text('anual')
    expect(page).to have_text('Descargar Archivo')
  end
end
