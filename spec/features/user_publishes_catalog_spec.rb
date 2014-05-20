require 'spec_helper'

feature User, 'publishes catalog:' do
  
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "can see a disabled publish link and catalog url" do
    given_has_uploaded_an_inventory(1.day.ago)
    visit new_inventory_path
    expect(page).to have_text("Paso 5")
    expect(page).to have_text("Publica tu inventario")
    expect(page).to have_css("#publish.disabled")
    expect(page).to have_link("Lo publicaré después, quiero avanzar")
  end

  scenario "sees permissions and publication requirements checkboxes" do
    given_has_uploaded_an_inventory(1.day.ago)
    visit new_inventory_path
    click_on "Guardar"
    sees_data_requirements
  end

  scenario "can publish a catalog", :js => true do
    given_has_uploaded_an_inventory(1.days.ago)
    visit new_inventory_path
    click_on "Guardar"
    check_publication_requirements
    click_on "Publicar"
    sees_success_message "LISTO, has completados todos los pasos. Ahora utiliza esta herramienta para mantener tu plan de apertura e inventario de datos al día."
    expect(page).to have_text "Última versión"
    expect(page).to have_text "Versión Publicada"
    expect(page).to have_text @user.name
    expect(page).to have_link "Subir nueva versión"
    expect(page).to have_link "Descargar esta versión"

  end

  def given_logged_in_as(user)
    visit "/users/sign_in"
    fill_in("Correo electrónico", :with => user.email)
    fill_in("Contraseña", :with => user.password)
    click_on("Entrar")
  end

  def given_has_uploaded_an_inventory(days_ago)
    @inventory = FactoryGirl.create(:inventory)
    @inventory.update_attributes(:author => @user.name, :organization_id => @user.organization_id, :created_at => days_ago)
  end

  def sees_data_requirements
    expect(page).to have_css("#personal_data")
    expect(page).to have_css("#open_data")
    expect(page).to have_css("#office_permission")
    expect(page).to have_css("#data_policy_requirements")
  end

  def check_publication_requirements
    check("personal_data")
    check("open_data")
    check("office_permission")
    check("data_policy_requirements")
    page.execute_script("$('#data_policy_requirements').trigger('change');")
  end

  def sees_success_message(message)
    expect(page).to have_text(message)
    expect(page).to have_css(".alert-success")
  end
end