require 'spec_helper'

feature User, 'manages inventory datasets crud:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'creates a new public dataset', js: true do
    within('.navbar') { click_on('Plan de Apertura') }

    click_link('Agregar un conjunto nuevo')

    dataset_attributes = attributes_for(:dataset)
    distribution_attributes = attributes_for(:distribution)

    fill_public_dataset_form(dataset_attributes)

    click_on('Agregar un recurso nuevo')
    fill_distribution_nested_form(distribution_attributes)
    click_on('Guardar')

    expect(current_path).to eq(inventories_datasets_path)
    find('tr.dataset td a.accordion-toggle', text: dataset_attributes[:title]).click

    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Público')
      expect(page).to have_text(dataset_attributes[:publish_date].strftime('%F'))
    end

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('JSON')
    end
  end

  scenario 'creates a new private dataset', js: true do
    within('.navbar') { click_on('Plan de Apertura') }
    click_link('Agregar un conjunto nuevo')

    dataset_attributes = attributes_for(:dataset)
    distribution_attributes = attributes_for(:distribution)

    fill_private_dataset_form(dataset_attributes)
    click_on('Agregar un recurso nuevo')
    fill_distribution_nested_form(distribution_attributes)
    click_on('Guardar')

    find('tr.dataset td a.accordion-toggle', text: dataset_attributes[:title]).click

    expect(current_path).to eq(inventories_datasets_path)
    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Privado')
    end

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('JSON')
    end
  end

  scenario 'edits a dataset', js: true do
    dataset = given_an_inventory_with_a_dataset

    within('.navbar') { click_on('Plan de Apertura') }

    within find('tr.dataset', text: dataset[:title]) do
      click_on('Editar')
    end

    dataset_attributes = attributes_for(:dataset)
    fill_public_dataset_form(dataset_attributes)
    click_on('Guardar')

    expect(current_path).to eq(inventories_datasets_path)
    find('tr.dataset td a.accordion-toggle', text: dataset_attributes[:title]).click
    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)

    within find('tr.dataset', text: dataset_attributes[:title]) do
      expect(page).to have_text('Público')
      expect(page).to have_text(dataset_attributes[:publish_date].strftime('%F'))
    end
  end

  scenario 'deletes a dataset', js: true do
    dataset = given_an_inventory_with_a_dataset
    within('.navbar') { click_on('Plan de Apertura') }

    within find('tr.dataset', text: dataset[:title]) do
      click_on('Eliminar')
    end

    click_on('Eliminar Conjunto')

    expect(page).to have_css('.table tbody tr.dataset', count: 0)
    expect(page).not_to have_text(dataset[:title])
  end

  scenario 'adds a distribution to a dataset', js: true do
    dataset = given_an_inventory_with_a_dataset
    within('.navbar') { click_on('Plan de Apertura') }

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click
    within find('tr td.add-distribution') do
      click_on('Agregar un recurso nuevo')
    end

    distribution_attributes = attributes_for(:distribution)
    fill_distribution_form(distribution_attributes, 'json')

    click_on('Guardar')

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click
    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 2)

    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('JSON')
    end
  end

  scenario 'edits a dataset distribution', js: true do
    dataset = given_an_inventory_with_a_dataset
    within('.navbar') { click_on('Plan de Apertura') }

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click
    within find('tr.distribution', text: dataset[:distributions].first[:title]) do
      click_on('Editar')
    end

    distribution_attributes = attributes_for(:distribution)
    fill_distribution_form(distribution_attributes, 'json')
    click_on('Guardar')

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click
    within find('tr.distribution', text: distribution_attributes[:title]) do
      expect(page).to have_text('JSON')
    end

    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 1)
    expect(page).not_to have_text(dataset[:distributions].first[:title])
  end

  scenario 'deletes a distribution', js: true do
    dataset = given_an_inventory_with_a_dataset
    within('.navbar') { click_on('Plan de Apertura') }

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click
    within find('tr.distribution', text: dataset[:distributions].first[:title]) do
      click_on('Eliminar')
    end

    click_on('Eliminar Recurso')

    find('tr.dataset td a.accordion-toggle', text: dataset[:title]).click

    expect(page).to have_css('.table tbody tr.dataset', count: 1)
    expect(page).to have_css('.table tbody tr.distribution', count: 0)
    expect(page).not_to have_text(dataset[:distributions].first[:title])
  end

  def given_an_inventory_with_a_dataset
    dataset = attributes_for(:dataset)
    distribution = attributes_for(:distribution)
    dataset[:distributions] = [distribution]

    within('.navbar') { click_on('Plan de Apertura') }
    click_link('Agregar un conjunto nuevo')

    fill_public_dataset_form(dataset)
    click_on('Agregar un recurso nuevo')
    fill_distribution_nested_form(distribution)
    click_on('Guardar')

    dataset
  end

  def fill_public_dataset_form(dataset_attributes)
    fill_in('dataset_title', with: dataset_attributes[:title])
    fill_in('dataset_description', with: dataset_attributes[:description])
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    select('Público', from: 'dataset_public_access')
    fill_in('dataset_publish_date', with: dataset_attributes[:publish_date].strftime('%F'))
    select('Diario', from: 'dataset_accrual_periodicity')
  end

  def fill_private_dataset_form(dataset_attributes)
    fill_in('dataset_title', with: dataset_attributes[:title])
    fill_in('dataset_description', with: dataset_attributes[:description])
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    select('Privado', from: 'dataset_public_access')
    select('Diario', from: 'dataset_accrual_periodicity')
  end

  def fill_distribution_nested_form(distribution_attributes)
    within('.fields') do
      find("input[id^='dataset_distributions_attributes_'][id$='title']").set(distribution_attributes[:title])
      find("textarea[id^='dataset_distributions_attributes_'][id$='description']").set(distribution_attributes[:description])
      find("input[id^='dataset_distributions_attributes_'][id$='publish_date']").set(distribution_attributes[:publish_date])
      select('json', from: 'media_type_select')
    end
  end

  def fill_distribution_form(distribution_attributes, media_type)
    fill_in('distribution_title', with: distribution_attributes[:title])
    fill_in('distribution_description', with: distribution_attributes[:description])
    fill_in('distribution_publish_date', with: distribution_attributes[:publish_date].strftime('%F'))
    select(media_type, from: 'media_type_select')
  end
end
