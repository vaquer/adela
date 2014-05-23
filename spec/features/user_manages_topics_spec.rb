# encoding: UTF-8

require 'spec_helper'

feature User, 'manages topics:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
    click_link "Plan de apertura"
  end

  scenario "can see a button and a message to add first topic" do
    page.should have_button("Agregar nueva área o tema")
    sees_success_message "Bienvenido, el primer paso es crear tu plan de apertura"
  end

  scenario "can add a new topic", :js => true do
    click_button "Agregar nueva área o tema"
    fill_in "Área o tema", :with => "El nombre del tema"
    fill_in "Responsable", :with => "Fulanito Perez"
    fill_in "Posible proyecto", :with => "Descripción de actividades"
    click_button "Guardar"

    within "#topics-listing" do
      page.should have_content "El nombre del tema"
      page.should have_content "Fulanito Perez"
      page.should have_content "Descripción de actividades"
    end
  end
end
