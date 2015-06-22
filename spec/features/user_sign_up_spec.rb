require 'spec_helper'

feature User, 'sign up:' do

  scenario "visits root page and sees log in link" do
    visit "/"
    expect(page).to have_link("Regístrate")
  end

  scenario "sees the sign up form" do
    visit "/"
    click_link("Regístrate")
    expect(current_path).to eq(new_user_registration_path)
    expect(page).to have_css("#user_email")
    expect(page).to have_css("#user_name")
    expect(page).to have_css("#user_password")
    expect(page).to have_css("#user_password_confirmation")
    expect(page).to have_selector("input[type=submit]")
  end

  scenario "succeed to sign up with a valid account" do
    visit new_user_registration_path
    fill_the_form
    click_button("Regístrate")
    expect(current_path).to eq(root_path)
  end

  def fill_the_form
    user = FactoryGirl.build(:user)
    fill_in("user_email", :with => user.email)
    fill_in("user_name", :with => user.name)
    fill_in("user_password", :with => "secretpassword")
    fill_in("user_password_confirmation", :with => "secretpassword")
  end
end
