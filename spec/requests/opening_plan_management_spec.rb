require 'spec_helper'

feature "opening plan management" do
  background do
    file = File.new("#{Rails.root}/spec/fixtures/files/inventory-with-opening-plan.csv")
    @inventory = FactoryGirl.create(:published_inventory, csv_file: file)
  end

  it "returns the organization opening plan" do
    get "/#{@inventory.organization.slug}/plan.json"
    expect(response).to match_response_schema("opening_plan")
  end
end
