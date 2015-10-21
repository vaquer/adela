require 'spec_helper'

feature User, 'updates opening plan:' do
  before do
    @organization = create :organization, :opening_plan
    @user = FactoryGirl.create(:user, organization: @organization)
    given_logged_in_as(@user)
  end

  scenario 'and sees warning message' do
    opening_plan = @organization.opening_plans.first

    click_link 'Plan de Apertura'
    expect(page).to have_content opening_plan.name
    expect(page).to have_content opening_plan.description

    click_link 'Actualizar Plan de Apertura'

    expect(page).to have_content "Los cambios al Plan de Apertura Institucional se verán reflejados en el Catálogo de Datos."
    expect(page).to have_field "Mensaje"

    fill_in "organization_opening_plans_attributes_0_description", with: "New description"
    fill_in "Mensaje", with: "Commit message"
    click_button "Generar Plan de Apertura"

    expect(page).to have_content opening_plan.name
    expect(page).not_to have_content opening_plan.description
    expect(page).to have_content "New description"

    click_link "Catálogo de Datos"
    expect(page).to have_content "New description"
    expect(page).not_to have_content opening_plan.description
  end
end
