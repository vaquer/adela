require 'spec_helper'

feature Admin, 'manages users:' do

  scenario "can add users from csv file" do
    visit "/admin"

    expect(page).to have_text "Csv con usuarios"
    upload_the_file "adela-users.csv"

    sees_success_message "Los usuarios se crearon exitosamente."
    User.count.should == 2
    User.all.map(&:name).should == ["Octavio Pérez", "Enrique Pena"]
  end

  def upload_the_file(file_name)
    attach_file('csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Crear usuarios del archivo")
  end
end