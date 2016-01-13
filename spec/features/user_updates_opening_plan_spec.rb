require 'spec_helper'

feature User, 'updates opening plan:' do
  before do
    @organization = create :organization, :opening_plan
    @user = FactoryGirl.create(:user, organization: @organization)
    given_logged_in_as(@user)
  end

  scenario 'and sees warning message' do
    skip
    opening_plan = @organization.opening_plans.first

    click_link 'Plan de Apertura'
    expect(page).to have_content opening_plan.name
    expect(page).to have_content opening_plan.description

    click_link 'Actualizar Plan de Apertura'

    expect(page).to have_content "Los cambios al Plan de Apertura Institucional se verán reflejados en el Catálogo de Datos."
    expect(page).to have_field "Mensaje"

    fill_in "catalog_datasets_attributes_0_description", with: "New description"
    fill_in "Mensaje", with: "Commit message"
    click_button "Generar Plan de Apertura"

    expect(page).to have_content opening_plan.name
    expect(page).not_to have_content opening_plan.description
    expect(page).to have_content "New description"

    click_link "Catálogo de Datos"
    expect(page).to have_content "New description"
    expect(page).not_to have_content opening_plan.description
  end

  scenario 'and generates catalog with consistent data' do
    skip
    changing_opening_plan = create :opening_plan, organization: @organization, publish_date: 2.days.from_now
    @organization.reload
    changing_opening_plan_index = @organization.opening_plans.size - 1
    given_organization_inventory_element_with changing_opening_plan.name
    given_organization_has_empty_catalog

    opening_plans = @organization.opening_plans
    click_link 'Plan de Apertura'

    opening_plans.each do |opening_plan|
      expect(page).to have_content opening_plan.name
    end

    visit new_opening_plan_path
    uncheck "catalog_datasets_attributes_#{changing_opening_plan_index}__destroy"
    fill_in "catalog_datasets_attributes_#{changing_opening_plan_index}_description", with: "Changing description"
    fill_in "catalog_datasets_attributes_#{changing_opening_plan_index}_publish_date", with: "2015-11-11"

    click_button "Generar Plan de Apertura"
    click_link "Catálogo de Datos"

    expect(page).not_to have_content changing_opening_plan.name
    expect(page).not_to have_content "11-Nov-2015"

    visit new_opening_plan_path
    check "catalog_datasets_attributes_#{changing_opening_plan_index}__destroy"
    fill_in "catalog_datasets_attributes_#{changing_opening_plan_index}_description", with: "Changing description"
    fill_in "catalog_datasets_attributes_#{changing_opening_plan_index}_publish_date", with: "2015-10-10"

    click_button "Generar Plan de Apertura"
    click_link "Catálogo de Datos"

    opening_plans.each do |opening_plan|
      expect(page).to have_content opening_plan.name
    end

    expect(page).to have_content changing_opening_plan.name
    expect(page).not_to have_content "10-Oct-2015"
    expect(catalog_with_no_duplicated_datasets).to be
  end

  scenario "and doesn't deletes the previous opening plan" do
    given_organization_has_catalog
    click_link 'Plan de Apertura'
    click_link 'Actualizar Plan de Apertura'
    click_link 'Plan de Apertura'

    @organization.catalog.datasets.each do |dataset|
      expect(page).to have_content(dataset.title)
      expect(page).to have_content(dataset.description)
    end
  end

  def given_organization_inventory_element_with(name)
    inventory = @organization.inventories.last
    inventory.inventory_elements << (create :inventory_element, dataset_title: name)
    inventory.save
  end

  def given_organization_has_empty_catalog
    create :catalog, datasets: [], organization: @organization
    @organization.reload
  end

  def catalog_with_no_duplicated_datasets
    @organization.reload
    @organization.catalog.datasets.map(&:title).uniq.size == @organization.catalog.datasets.size
  end
end
