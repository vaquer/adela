require 'spec_helper'
require 'sidekiq/testing'

feature Admin, 'manages users:' do

  def upload_the_file(file_name)
    attach_file('csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Importar usuarios")
  end

  context "as an admin" do
    background do
      @admin = FactoryGirl.create(:admin)
      given_logged_in_as(@admin)
    end

    scenario "can add users from csv file" do
      visit "/admin"

      expect(page).to have_text "Archivo csv"
      upload_the_file "adela-users.csv"

      sees_success_message "Los usuarios se crearon exitosamente."
      User.count.should == 3
      User.all.map(&:name).sort.should == [ "Rodrigo", "Octavio Pérez", "Enrique Pena" ].sort
    end

    scenario "sees registered users" do
      visit "/admin"

      user1 = FactoryGirl.create(:user, :name => "Antonio Gómez", :last_sign_in_at => 1.seconds.from_now)
      user2 = FactoryGirl.create(:user, :name => "Margarita Soto", :last_sign_in_at => 1.seconds.from_now)
      expect(page).to have_link "Ver usuarios registrados"

      click_on "Ver usuarios registrados"
      expect(page).to have_text user1.name
      expect(page).to have_text user2.name
    end

    scenario "can act as an organization member" do
      organization = FactoryGirl.create(:organization, :title => "SEP")
      user = FactoryGirl.create(:user, :name => "Antonio Gómez", :organization => organization)

      visit "/admin"
      click_on "Ver organizaciones"

      expect(page).to have_text organization.title
      expect(page).to have_link "Acceder como #{user.name}(#{user.email})"

      click_on "Acceder como #{user.name}(#{user.email})"

      expect(page).to have_text "Estás en ADELA como #{user.name} de #{organization.title}."
      expect(page).to have_link "Volver al administrador"

      click_on "Volver al administrador"

      expect(page).to have_text "ORGANIZACIONES"
    end
  end

  context "as an supervisor" do
    background do
      @supervisor = FactoryGirl.create(:supervisor)
      given_logged_in_as(@supervisor)
    end

    scenario "can add users from csv file" do
      visit "/admin"

      expect(page).to have_text "Archivo csv"
      upload_the_file "adela-users.csv"

      sees_success_message "Los usuarios se crearon exitosamente."
      User.count.should == 3
      User.all.map(&:name).sort.should == [ "Rodrigo", "Octavio Pérez", "Enrique Pena" ].sort
    end
  end
end