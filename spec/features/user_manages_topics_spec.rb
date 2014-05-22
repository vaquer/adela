require 'spec_helper'

feature User, 'manages topics:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "can see a button and a message to add first topic" do
    click_link "Plan de apertura"
    page.should have_button("Agregar nueva área o tema")
    sees_success_message "Bienvenido, el primer paso es crear tu plan de apertura"
  end
end
