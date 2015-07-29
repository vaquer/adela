require 'spec_helper'

feature Organization, 'manages dashboard:' do
  background do
    @user = FactoryGirl.create(:user)
    @organization = @user.organization
    given_logged_in_as(@user)
  end

  scenario "sees the last inventory version" do
    given_has_uploaded_an_inventory 10.days.ago
    visit organization_path(@organization)
    click_on "Actualizar catálogo"
    expect(page).to have_text "Última versión"
    expect(page).to have_text "#{I18n.l(10.days.ago, :format => :short)}"
  end

  scenario "sees older inventory versions" do
    given_has_uploaded_an_inventory 10.days.ago
    given_has_published_an_inventory 5.days.ago
    visit organization_path(@organization)
    click_on "Actualizar catálogo"
    expect(page).to have_text "Versiones pasadas"
    expect(page).to have_text "#{I18n.l(10.days.ago, :format => :short)}"
  end

  scenario "can publish last inventory version", :js => true do
    given_has_uploaded_an_inventory 5.days.ago
    given_has_published_an_inventory 10.days.ago
    visit organization_path(@organization)
    click_on "Actualizar catálogo"
    expect(page).to have_text "La versión publicada no es la última versión."
    click_on "Publicar última versión"
    expect(page).to have_text "Paso 5"
    check_publication_requirements
    click_on "Publicar"
    page.should_not have_content("Publicar última versión")
  end

  def given_has_uploaded_an_inventory(days_ago)
    @inventory = FactoryGirl.create(:inventory)
    @inventory.update_attributes(:author => @user.name, :organization_id => @organization.id, :created_at => days_ago)
  end

  def given_has_published_an_inventory(days_ago)
    @inventory = FactoryGirl.create(:published_inventory, :publish_date => days_ago)
    @inventory.update_attributes(:author => @user.name, :organization_id => @organization.id, :created_at => days_ago)
  end

  def check_publication_requirements
    check("personal_data")
    check("open_data")
    check("office_permission")
    check("data_policy_requirements")
    page.execute_script("$('#data_policy_requirements').trigger('change');")
  end
end
