require 'spec_helper'

feature Organization, 'manages profile:' do
  background do
    @user = FactoryGirl.create(:user)
    @organization = @user.organization
    given_logged_in_as(@user)
  end

  scenario 'sees profile options', js: true do
    visit organization_path(@organization)

    expect(page).to have_link(@user.name)
    click_on(@user.name)
    click_on 'Editar Perfil'

    expect(page).to have_text 'Nombre'
    expect(page).to have_text 'Descripción'
    expect(page).to have_text 'Sitio Web'
    expect(page).to have_text 'Tipo de Gobierno'
  end

  scenario 'edit description and logo url', js: true do
    visit profile_organization_path(@organization)

    fill_in 'Nombre', with: Faker::Company.name
    fill_in 'Descripción', with: 'Esta es una descripción de una institución'
    fill_in 'Sitio Web', with: Faker::Internet.url
    select 'Federal', from: 'organization[gov_type]'
    click_button 'Guardar'

    sees_success_message 'El perfil se ha actualizado con éxito.'
  end

  scenario "can't see or edit another organization" do
    @not_my_organization = FactoryGirl.create(:organization)

    visit profile_organization_path(@not_my_organization)

    expect(page).not_to have_content 'Descripción'
    expect(page).not_to have_content 'URL Logo'
    expect(current_path).to eq(organization_path(@not_my_organization))
  end
end
