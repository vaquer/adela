require 'spec_helper'

feature User, 'manages inventory datasets crud:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'creates a new public dataset', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    click_link('add-new-dataset')

    dataset_attributes = attributes_for(:dataset)
    distribution_attributes = attributes_for(:distribution)

    fill_public_dataset_form(dataset_attributes)
    click_on('Agregar Recurso')
    fill_distribution_nested_form(distribution_attributes)
    click_on('Guardar')

    expect(current_path).to eq(inventories_path)
    expect(page).to have_css('.table tbody tr.dataset', count: 2)
    expect(page).to have_css('.table tbody tr.distribution', count: 2)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Público')
      expect(page).to have_text(dataset_attributes[:publish_date].strftime('%F'))
    end

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('json')
    end
  end

  scenario 'creates a new private dataset', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }
    click_link('add-new-dataset')

    dataset_attributes = attributes_for(:dataset)
    distribution_attributes = attributes_for(:distribution)

    fill_private_dataset_form(dataset_attributes)
    click_on('Agregar Recurso')
    fill_distribution_nested_form(distribution_attributes)
    click_on('Guardar')

    expect(current_path).to eq(inventories_path)
    expect(page).to have_css('.table tbody tr.dataset', count: 2)
    expect(page).to have_css('.table tbody tr.distribution', count: 2)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Privado')
    end

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('json')
    end
  end

  scenario 'cannot create a new dataset without distribution', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }
    click_link('add-new-dataset')

    expect(page).not_to have_text('Guardar')
  end

  scenario 'edits a dataset', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within find('tr.dataset', text: 'Mantenimiento Portuario') do
      find('.dropdown').click
      click_on('Editar')
    end

    dataset_attributes = attributes_for(:dataset)
    fill_public_dataset_form(dataset_attributes)
    click_on('Guardar')

    expect(current_path).to eq(inventories_path)
    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Público')
      expect(page).to have_text(dataset_attributes[:publish_date].strftime('%F'))
    end

    within find('tr.distribution', text: 'Programa anual de Mantenimiento') do
      expect(page).to have_text('Excel')
    end
  end

  scenario 'deletes a dataset', js: true do
    upload_inventory_with_file('inventario_general_de_datos.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within find('tr.dataset', text: 'Tipos de vegetación') do
      find('.dropdown').click
      click_on('Eliminar')
    end

    expect(page).to have_css('.table tbody tr.dataset', count: 2)
    expect(page).to have_css('.table tbody tr.distribution', count: 2)

    expect(page).not_to have_text('Tipos de vegetación')
    expect(page).not_to have_text('bosque de encinos, bosquie de coniferas, selva prenifolia, etc.')
  end

  scenario 'adds a distribution to a dataset', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within find('tr.dataset', text: 'Mantenimiento Portuario') do
      find('.dropdown').click
      click_on('Agregar')
    end

    distribution_attributes = attributes_for(:distribution)
    fill_distribution_form(distribution_attributes, 'json')
    click_on('Guardar')

    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 2)

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('json')
    end
  end

  scenario 'edits a dataset distribution', js: true do
    upload_inventory_with_file('another-inventory-spreadsheet-file.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within find('tr.distribution', text: 'Programa anual de Mantenimiento') do
      find('.dropdown').click
      click_on('Editar')
    end

    distribution_attributes = attributes_for(:distribution)
    fill_distribution_form(distribution_attributes, 'json')
    click_on('Guardar')

    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('json')
    end
    expect(page).not_to have_text('Programa anual de Mantenimiento')
  end

  scenario 'deletes a distribution', js: true do
    upload_inventory_with_file('inventario_general_de_datos_update.xlsx')
    within('.navbar') { click_on('Inventario de Datos') }

    within find('tr.distribution', text: 'Desierto') do
      find('.dropdown').click
      click_on('Eliminar')
    end

    expect(page).to have_css('.table tbody tr.dataset', count: 3)
    expect(page).to have_css('.table tbody tr.distribution', count: 3)
    expect(page).not_to have_text('Desierto')
  end

  def fill_public_dataset_form(dataset_attributes)
    fill_in('dataset_title', with: dataset_attributes[:title])
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    select('Público', from: 'dataset_public_access')
    fill_in('dataset_publish_date', with: dataset_attributes[:publish_date].strftime('%F'))
  end

  def fill_private_dataset_form(dataset_attributes)
    fill_in('dataset_title', with: dataset_attributes[:title])
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    select('Privado', from: 'dataset_public_access')
  end

  def fill_distribution_nested_form(distribution_attributes)
    within('.fields') do
      find("input[id^='dataset_distributions_attributes_'][id$='title']").set(distribution_attributes[:title])
      find("textarea[id^='dataset_distributions_attributes_'][id$='description']").set(distribution_attributes[:description])
      select('json', from: 'media_type_select')
    end
  end

  def fill_distribution_form(distribution_attributes, media_type)
    fill_in('distribution_title', with: distribution_attributes[:title])
    fill_in('distribution_description', with: distribution_attributes[:description])
    select(media_type, from: 'media_type_select')
  end
end
