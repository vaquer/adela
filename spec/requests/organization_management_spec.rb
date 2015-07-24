require 'spec_helper'

feature "opening plan management" do
  background do
    @organization = FactoryGirl.create(:organization)
  end

  it "returns the organization opening plan" do
    get "/instituciones/#{@organization.slug}.json"
    expect(response).to match_response_schema("organization")
  end
end
