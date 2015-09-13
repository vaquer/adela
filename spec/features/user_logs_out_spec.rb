require 'spec_helper'

feature User, 'logs out:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees user home page" do
    expect(current_path).to eq(organization_path(@user.organization))
  end

  scenario "sees the log out link" do
    visit "/"
    expect(page).to have_text("Cerrar sesión")
  end

  scenario "succeed to log out", :js => true do
    visit "/"
    expect(page).to have_link(@user.name)
    click_on(@user.name)
    click_on "Cerrar sesión"
    sees_success_message "Usted ha salido del sistema."
  end
end
