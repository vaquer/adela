require 'spec_helper'

feature User, 'logs out:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees user home page" do
    expect(current_path).to eq(new_inventory_path)
  end

  scenario "sees user organization title" do
    expect(page).to have_text(@user.organization.title)
  end

  scenario "sees the log out link" do
    visit "/"
    expect(page).to have_text("Cerrar sesión")
  end

  scenario "succeed to log out" do
    visit "/"
    click_on("Cerrar sesión")
    sees_success_message "Usted ha salido del sistema."
  end
end
