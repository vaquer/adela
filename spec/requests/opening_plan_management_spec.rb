require 'spec_helper'

feature "opening plan management" do
  background do
    file = File.new("#{Rails.root}/spec/fixtures/files/catalog-with-opening-plan.csv")
    @catalog = FactoryGirl.create(:published_catalog, csv_file: file)
  end

  it "returns the organization opening plan" do
    get "/#{@catalog.organization.slug}/plan.json"
    expect(response).to match_response_schema("opening_plan")
  end
end
