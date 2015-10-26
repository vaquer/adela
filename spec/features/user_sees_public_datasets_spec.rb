require 'spec_helper'

feature User, 'has inventory containing some private datasets:' do
  before do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'and sees only public elements in the catalog', js: true do
    given_organization_has_catalog

    inventory = @user.organization.inventories.last
    expect(inventory.datasets.select(&:private?).size).to be > 0

    click_link "Catálogo de Datos"

    inventory.datasets.each do |e|
      if e.private?
        expect(page).not_to have_content e.dataset_title
      else
        expect(page).to have_content e.dataset_title
      end
    end
  end

  def given_organization_has_catalog
    inventory = create(:inventory, :elements, organization: @user.organization)
    InventoryXLSXParserWorker.new.perform(inventory.id)

    org = @user.organization
    generate_new_opening_plan

    CatalogDatasetsGenerator.new(org).execute
    @user.organization.reload
  end

end


