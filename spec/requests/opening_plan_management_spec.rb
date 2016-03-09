require 'spec_helper'

feature 'opening plan management' do
  let(:opening_plan) { create(:catalog_with_opening_plan) }

  it 'returns the organization opening plan' do
    sleep 1
    get "/#{opening_plan.organization.slug}/plan.json"
    expect(response).to match_response_schema('opening_plan')
  end
end
