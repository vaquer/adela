require 'spec_helper'

feature User, 'manages inventory actions:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  xscenario 'downloads the inventry plan', js: true do
    upload_inventory_with_file('inventario_general_de_datos.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within('.btn-group') do
      click_on('Acciones')
      have_text('Descargar')
    end
  end

  scenario 'continue with opening plan' do
    upload_inventory_with_file('inventario_general_de_datos.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }
    click_on('Continua con el Plan de Apertura')
    expect(current_path).to eq(new_opening_plan_path)
  end
end
