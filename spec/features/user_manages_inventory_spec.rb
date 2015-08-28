require 'spec_helper'

feature User, 'manages inventory:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'sees inventory card' do
    expect(page).to have_text('Planea')
    expect(page).to have_text('Descargar')
    expect(page).to have_text('Subir')
  end

  scenario 'uploads a valid inventory file' do
    click_on('Subir')
    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx")
    click_on('Subir inventario')

    expect(page).to have_text('Archivo enviado')
    expect(page).to have_text("Publicación del inventario institucional de Datos de #{@user.organization.title}")
  end

  scenario 'uploads an invalid inventory file with no comments for private datasets' do
    click_on('Subir')
    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos_error_privado.xlsx")
    click_on('Subir inventario')

    expect(page).to have_text('Archivo enviado')
    expect(page).to have_text('Se encontraron las siguientes observaciones en el archivo de Inventario de Datos:')
    expect(page).to have_text('Renglón 2')
    expect(page).to have_text('Cuando el valor del dato ¿Tiene datos privados? no es Público la columna F no puede estar vacía o nula.')
  end

  scenario 'uploads an invalid inventory file with no publish date for public datasets' do
    click_on('Subir')
    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos_error_publico.xlsx")
    click_on('Subir inventario')

    expect(page).to have_text('Archivo enviado')
    expect(page).to have_text('Se encontraron las siguientes observaciones en el archivo de Inventario de Datos:')
    expect(page).to have_text('Renglón 2')
    expect(page).to have_text('Cuando el valor del dato ¿Tiene datos privados? es Público la fecha estimada de publicación no puede estar vacía o nula.')
  end

  scenario 'uploads an invalid inventory file with no publish date for public datasets' do
    click_on('Subir')
    attach_file('inventory_spreadsheet_file', "#{Rails.root}/spec/fixtures/files/inventario_general_de_datos_error_fecha.xlsx")
    click_on('Subir inventario')

    expect(page).to have_text('Archivo enviado')
    expect(page).to have_text('Se encontraron las siguientes observaciones en el archivo de Inventario de Datos:')
    expect(page).to have_text('Renglón 2')
    expect(page).to have_text('La fecha estimada de publicación no está en el formato AAAA-MM.')
  end
end
