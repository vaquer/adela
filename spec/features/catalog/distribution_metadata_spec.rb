require 'spec_helper'

feature 'Catalog distribution metadata' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'fills the distribution metadata' do
    catalog = create(:catalog, organization: @user.organization)
    dataset = create(:opening_plan_dataset, catalog: catalog)
    distribution = dataset.distributions.first
    visit edit_distribution_path(distribution)

    distribution_attributes = attributes_for(:distribution)
    fill_catalog_distribution_metadata(distribution_attributes)

    visit edit_distribution_path(distribution)
    expect(page).to have_field('distribution_download_url', with: distribution_attributes[:download_url])
    expect(page).to have_field('distribution_modified', with: distribution_attributes[:modified].strftime('%F'))
    expect(page).to have_field('distribution_byte_size', with: distribution_attributes[:byte_size])
    expect(page).to have_field('distribution_spatial', with: distribution_attributes[:spatial])
  end

  def fill_catalog_distribution_metadata(distribution_attributes)
    fill_in('distribution_download_url', with: distribution_attributes[:download_url])
    fill_in('distribution_modified', with: distribution_attributes[:modified].strftime('%F'))
    fill_in('distribution_byte_size', with: distribution_attributes[:byte_size])
    fill_in('distribution_spatial', with: distribution_attributes[:spatial])
    # page.find('form').click # close the date picker by clicking anywhere
    click_on('Guardar')
  end
end
