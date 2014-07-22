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
end