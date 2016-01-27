require 'spec_helper'

feature User, 'has inventory containing some private datasets:' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'and sees only public elements in the catalog' do
    given_organization_with_opening_plan
    private_dataset_attributes = attributes_for(:dataset, public_access: false)
    @user.organization.catalog.datasets.create(private_dataset_attributes)
    click_link 'Catálogo de Datos'

    expect(page).not_to have_content(private_dataset_attributes[:title])
  end
end
