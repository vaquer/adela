require 'spec_helper'
require 'sidekiq/testing'

feature Admin, 'manages users:' do
  background do
    @admin = FactoryGirl.create(:admin)
    given_logged_in_as(@admin)
  end

  scenario "sees users menu" do
    visit "/admin"
    expect(page).to have_link "Administrar Usuarios"
    click_on "Administrar Usuarios"
    expect(current_path).to eq(admin_users_path)
  end

  scenario "can add users from csv file" do
    visit "/admin/users"
    click_on 'Importar Usuarios'

    expect(page).to have_text "Archivo csv"
    upload_the_file "adela-users.csv"

    sees_success_message "Los usuarios se crearon exitosamente."
    User.count.should == 3
  end

  scenario "can create an new user" do
    organization = FactoryGirl.create(:organization)
    visit "/admin/users"
    click_on 'Crear Usuario'

    fill_in('Nombre', with: Faker::Name.name)
    fill_in('Correo electrónico', with: Faker::Internet.email)
    select(organization.title, from: 'user_organization_id')

    click_on 'Guardar'
    sees_success_message "El usuario se creó exitosamente."
    expect(User.count).to eq(2)
    expect(page).to have_text organization.title
  end

  scenario "sees users in admin" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)

    visit "/admin/users"
    expect(page).to have_text user1.name
    expect(page).to have_text user2.name
  end

  scenario "can edit an user", js: true do
    user = FactoryGirl.create(:user)
    organization =  FactoryGirl.create(:organization)
    new_name  = Faker::Name.name
    new_email = Faker::Internet::email

    visit "/admin/users"
    expect(page).to have_css("#user_#{user.id}")
    page.find("#user_#{user.id}").click
    click_on 'Editar'

    fill_in('Nombre', with: new_name)
    fill_in('Correo electrónico', with: new_email)
    select(organization.title, from: 'user_organization_id')
    click_on 'Guardar'

    sees_success_message 'Se ha actualizado el usuario exitosamente.'
    expect(current_path).to eq(admin_users_path)
    expect(page).to have_text new_name
    expect(page).to have_text organization.title
    expect(page).to have_text new_email

  end

  scenario "can update an user password" do
    user = FactoryGirl.create(:user)
    new_password = Faker::Internet.password

    visit edit_admin_user_path(user)
    click_on 'Cambiar Contraseña'
    expect(current_path).to eq edit_password_admin_user_path(user)

    fill_in('Contraseña', with: new_password)
    fill_in('Confirmación de contraseña', with: new_password)
    click_on 'Guardar'

    valid_password = user.reload.valid_password?(new_password)
    expect(valid_password).to be true
  end

  scenario "can delete an user", js: true do
    user = FactoryGirl.create(:user)
    visit "/admin/users"

    expect(page).to have_css("#user_#{user.id}")
    page.find("#user_#{user.id}").click
    click_on 'Borrar'
    page.driver.browser.switch_to.alert.accept
    sleep(1) # test requires sleep to work
    expect(current_path).to eq(admin_users_path)
    expect(page).to have_no_text user.name
    expect(page).to have_no_text user.email
  end

  scenario "can act as an organization member", js: true do
    organization = FactoryGirl.create(:organization)
    user = FactoryGirl.create(:user, organization: organization)

    visit "/admin/users"
    expect(page).to have_text organization.title

    expect(page).to have_css("#user_#{user.id}")
    page.find("#user_#{user.id}").click
    click_on "Ingresar"

    expect(page).to have_text "Estás en ADELA como #{user.name} de #{organization.title}."
    expect(page).to have_link "Volver al administrador"

    click_on "Volver al administrador"
    expect(current_path).to eq(admin_root_path)
  end

  def upload_the_file(file_name)
    attach_file('csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Importar usuarios")
  end
end
