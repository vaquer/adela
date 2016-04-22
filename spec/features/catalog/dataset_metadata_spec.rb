require 'spec_helper'

feature 'Catalog dataset metadata' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'fills the dataset metadata', js: true do
    given_organization_with_catalog
    within('.navbar') { click_on('Catálogo de Datos') }
    close_joyride

    within set_row do
      click_on('Editar')
    end

    dataset_attributes = attributes_for(:dataset)
    fill_catalog_dataset_metadata(dataset_attributes)

    visit(current_path)

    expect(page).to have_field('dataset_contact_position', with: dataset_attributes[:contact_position])
    expect(page).to have_field('dataset_mbox', with: dataset_attributes[:mbox])
    expect(page).to have_field('dataset_landing_page', with: dataset_attributes[:landing_page])
    expect(page).to have_field('dataset_keyword', with: dataset_attributes[:keyword])
  end

  def fill_catalog_dataset_metadata(dataset_attributes)
    fill_in('dataset_contact_position', with: dataset_attributes[:contact_position])
    fill_in('dataset_mbox', with: dataset_attributes[:mbox])
    fill_in('dataset_landing_page', with: dataset_attributes[:landing_page])
    fill_in('dataset_keyword', with: dataset_attributes[:keyword])
    page.find('form').click # trigger the autosubmit by clicking anywhere
  end
end
