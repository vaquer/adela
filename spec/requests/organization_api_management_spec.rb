require 'spec_helper'

feature 'organization api management' do
  background do
    @organization = FactoryGirl.create(:organization)
  end

  it 'returns an organization JSON' do
    get "api/v1/organizations/#{@organization.slug}.json"
    expect(response).to match_response_schema('organization')
  end
end
