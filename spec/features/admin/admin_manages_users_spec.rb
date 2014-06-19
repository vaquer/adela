require 'spec_helper'
require 'sidekiq/testing'

feature Admin, 'manages users:' do

  scenario "can add users from csv file" do
    visit "/admin"

    expect(page).to have_text "Archivo csv"
    upload_the_file "adela-users.csv"

    sees_success_message "Los usuarios se crearon exitosamente."
    User.count.should == 2
    User.all.map(&:name).should == ["Octavio Pérez", "Enrique Pena"]
  end

  scenario "sees registered users" do
    visit "/admin"

    user1 = FactoryGirl.create(:user, :name => "Antonio Gómez", :last_sign_in_at => 1.seconds.from_now)
    user2 = FactoryGirl.create(:user, :name => "Margarita Soto", :last_sign_in_at => 1.seconds.from_now)
    expect(page).to have_link "Ver usuarios registrados"

    click_on "Ver usuarios registrados"
    expect(page).to have_text "Antonio Gómez"
    expect(page).to have_text "Margarita Soto"
  end

  def upload_the_file(file_name)
    attach_file('csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Importar usuarios")
  end
end