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

    expect(page).to have_link "Editar Perfil"
    click_on "Editar Perfil"

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

  scenario "can't see or edit another organization" do
    @not_my_organization = FactoryGirl.create(:organization)

    visit profile_organization_path(@not_my_organization)

    page.should_not have_content "Descripción"
    page.should_not have_content "URL Logo"
    expect(current_path).to eq(organization_path(@not_my_organization))
  end
end