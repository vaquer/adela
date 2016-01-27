require 'spec_helper'

feature 'opening plan management' do
  it 'returns the organization opening plan', skip: true do
    get "/#{opening_plan.organization.slug}/plan.json"
    expect(response).to match_response_schema('opening_plan')
  end
end
