require 'spec_helper'

feature 'Catalog distribution metadata' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'fills the distribution metadata', js: true do
    given_organization_with_catalog
    within('.navbar') { click_on('Catálogo de Datos') }

    within set_row do
      click_on('Documentar')
    end

    within resource_row do
      expect(page).to have_text('Falta información')
      click_on('Documentar')
    end

    distribution_attributes = attributes_for(:distribution)
    fill_catalog_distribution_metadata(distribution_attributes)

    within resource_row do
      expect(page).to have_text('Listo para publicar')
      click_on('Documentar')
    end

    expect(page).to have_field('distribution_download_url', with: distribution_attributes[:download_url])
    expect(page).to have_field('init-date', with: distribution_attributes[:temporal].split('/')[0])
    expect(page).to have_field('term-date', with: distribution_attributes[:temporal].split('/')[1])
    expect(page).to have_field('distribution_modified', with: distribution_attributes[:modified].strftime('%F'))
    expect(page).to have_field('distribution_byte_size', with: distribution_attributes[:byte_size])
  end

  def fill_catalog_distribution_metadata(distribution_attributes)
    fill_in('distribution_download_url', with: distribution_attributes[:download_url])
    fill_in('init-date', with: distribution_attributes[:temporal].split('/')[0])
    fill_in('term-date', with: distribution_attributes[:temporal].split('/')[1])
    fill_in('distribution_modified', with: distribution_attributes[:modified].strftime('%F'))
    fill_in('distribution_byte_size', with: distribution_attributes[:byte_size])
    page.find('form').click # close the date picker by clicking anywhere
    click_on('Guardar')
  end
end
