require 'spec_helper'

feature User, 'publishes catalog:' do

  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "can see a disabled publish link and catalog url" do
    given_has_uploaded_an_catalog(1.day.ago)
    visit new_catalog_path
    tries_to_upload_the_file("catalog.csv")
    expect(page).to have_text("Publica tu catálogo")
    expect(page).to have_css("#publish.disabled")
  end

  scenario "sees permissions and publication requirements checkboxes" do
    given_has_uploaded_an_catalog(1.day.ago)
    visit new_catalog_path
    tries_to_upload_the_file("catalog.csv")
    click_on "Guardar"
    sees_data_requirements
  end

  scenario "can publish a catalog" do
    visit new_catalog_path
    tries_to_upload_the_file("catalog.csv")
    click_on "Guardar catálogo"
    check_publication_requirements
    click_on "Publicar"
    expect(page).to have_text "Última versión"
    expect(page).to have_text "Versión publicada"
    expect(page).to have_text @user.name
    expect(page).to have_link "Subir nueva versión"
    @catalog = @user.organization.current_catalog
    activity_log_created_with_msg "publicó #{@catalog.datasets_count} conjuntos de datos con #{@catalog.distributions_count} recursos."
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
  end

  def tries_to_upload_the_file(file_name)
    attach_file('catalog_csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Subir catálogo")
  end

  def given_has_uploaded_an_catalog(days_ago)
    @catalog = FactoryGirl.create(:catalog)
    @catalog.update_attributes(:organization_id => @user.organization_id, :created_at => days_ago)
  end
end
