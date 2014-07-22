require 'spec_helper'

feature Organization, 'manages profile:' do
  background do
    @user = FactoryGirl.create(:user)
    @organization = @user.organization
    given_logged_in_as(@user)
  end

  scenario "sees profile options", :js => true do
    visit organization_path(@organization)

    find("#user_actions").click

    expect(page).to have_link "Perfil #{@organization.title}"
    click_on "Perfil #{@organization.title}"

    expect(page).to have_text "Descripción"
    expect(page).to have_text "URL Logo"
  end

  scenario "edit description and logo url", :js => true do
    visit profile_organization_path(@organization)

    fill_in "Descripción", :with => "Esta es una descripción de una institución"
    fill_in "URL Logo", :with => "http://www.imageurl.com"
    click_button "Guardar"

    expect(page).to have_text "El perfil se ha actualizado con éxito."
    expect(page).to have_text "Esta es una descripción de una institución"
  end
end