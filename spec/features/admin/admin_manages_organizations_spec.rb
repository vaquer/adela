require 'spec_helper'
require 'sidekiq/testing'

feature Admin, 'manages organizations:' do
  background do
    @admin = FactoryGirl.create(:admin)
    given_logged_in_as(@admin)
  end

  scenario "sees organizations menu" do
    visit "/admin"
    expect(page).to have_link "Administrar Organizaciones"
    click_on "Administrar Organizaciones"
    expect(current_path).to eq(admin_organizations_path)
  end

  scenario "can create an new organization" do
    organization = FactoryGirl.build(:federal_organization)
    visit "/admin/organizations"
    click_on 'Crear Organización'

    expect(current_path).to eq(new_admin_organization_path)
    fill_in('Nombre', with: organization.title)
    fill_in('Descripción', with: organization.description)
    fill_in('URL Logo', with: organization.logo_url)
    select(organization.gov_type_i18n, from: 'organization_gov_type')
    click_on 'Guardar'

    sees_success_message "La organización se creó exitosamente."
    expect(current_path).to eq(admin_organizations_path)
    expect(page).to have_text(organization.title)
    expect(page).to have_text(organization.gov_type_i18n)
  end

  scenario "can edit an organization", js: true do
    organization = FactoryGirl.create(:organization)
    new_attributes = FactoryGirl.attributes_for(:organization)
    visit "/admin/organizations"

    page.find("#organization_#{organization.id}").click
    click_on 'Editar'

    expect(current_path).to eq(edit_admin_organization_path(organization))
    fill_in('Nombre', with: new_attributes[:title])
    fill_in('Descripción', with: new_attributes[:description])
    fill_in('URL Logo', with: new_attributes[:logo_url])
    select('Federal', from: 'organization_gov_type')
    click_on 'Guardar'

    organization.reload
    sees_success_message 'Se ha actualizado la organización exitosamente.'
    expect(current_path).to eq(admin_organizations_path)
    expect(page).to have_text(organization.title)
    expect(page).to have_text('Federal')
  end

  scenario "can edit an organization gov_type", js: true do
    organization =  FactoryGirl.create(:organization)
    visit "/admin/organizations"

    page.find("#organization_#{organization.id}_gov_type").click
    click_on 'Cambiar a Estatal'

    sees_success_message 'Se ha actualizado la organización exitosamente.'
    expect(current_path).to eq(admin_organizations_path)
    expect(page).to have_text(organization.title)
    expect(page).to have_text('Estatal')
  end
end
