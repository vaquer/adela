require 'spec_helper'

feature 'Catalog dataset metadata' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'fills the dataset metadata', js: true do
    given_organization_with_catalog
    within('.navbar') { click_on('Catálogo de Datos') }

    within set_row do
      click_on('Documentar')
    end

    dataset_attributes = attributes_for(:dataset)
    fill_catalog_dataset_metadata(dataset_attributes)

    visit(current_path)

    expect(page).to have_field('dataset_contact_position', with: dataset_attributes[:contact_position])
    expect(page).to have_field('dataset_mbox', with: dataset_attributes[:mbox])
    expect(page).to have_field('dataset_spatial', with: dataset_attributes[:spatial])
    expect(page).to have_field('dataset_temporal', with: dataset_attributes[:temporal])
    expect(page).to have_field('dataset_landing_page', with: dataset_attributes[:landing_page])
    expect(page).to have_field('dataset_keyword', with: dataset_attributes[:keyword])
    expect(page).to have_field('dataset_comments', with: dataset_attributes[:comments])
  end

  def fill_catalog_dataset_metadata(dataset_attributes)
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    fill_in('dataset_mbox', with: dataset_attributes[:mbox])
    fill_in('dataset_spatial', with: dataset_attributes[:spatial])
    fill_in('dataset_temporal', with: dataset_attributes[:temporal])
    fill_in('dataset_landing_page', with: dataset_attributes[:landing_page])
    fill_in('dataset_keyword', with: dataset_attributes[:keyword])
    fill_in('dataset_comments', with: dataset_attributes[:comments])
    page.find('form').click # trigger the autosubmit by clicking anywhere
  end
end
