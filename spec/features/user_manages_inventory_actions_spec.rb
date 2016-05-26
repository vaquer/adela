require 'spec_helper'

feature User, 'manages inventory actions:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'downloads the inventry plan' do
    given_organization_with_catalog
    within('.navbar') { click_on('Plan de Apertura') }
    have_text('Descargar el plan de apertura actual')
  end

  scenario 'visits new inventories dataset path' do
    within('.navbar') { click_on('Plan de Apertura') }
    click_on('Agregar un conjunto nuevo')
    expect(current_path).to eq(new_inventories_dataset_path)
  end
end
