require 'spec_helper'

feature 'sectors api management' do
  background do
    10.times { create(:sector) }
  end

  it 'matches the organizations json schema' do
    get '/api/v1/sectors'
    expect(response).to match_response_schema('sectors')
  end
end
