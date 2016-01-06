require 'spec_helper'

feature "organizations api management" do
  let(:organization) { FactoryGirl.create(:organization) }

  it "matches the organizations json schema" do
    get "/api/v1/organizations"
    expect(response).to match_response_schema("organizations")
  end

  it "matches the gov_type json schema" do
    get "/api/v1/gov_types"
    expect(response).to match_response_schema("gov_types")
  end

  it "gets the organizations with federal gov_type" do
    organization = FactoryGirl.create(:organization, title: "sep", gov_type: "federal")
    get "/api/v1/organizations?gov_type=federal"
    json = JSON.parse(response.body)
    expect(json["results"].count).to eq(1)
  end

  it "gets the organizations with state gov_type" do
    organization = FactoryGirl.create(:organization, title: "Gobierno de Veracruz", gov_type: "state")
    get "/api/v1/organizations?gov_type=state"
    json = JSON.parse(response.body)
    expect(json["results"].count).to eq(1)
  end

  it "gets the organizations with municipal gov_type" do
    organization = FactoryGirl.create(:organization, title: "Huixquilucan", gov_type: "municipal")
    get "/api/v1/organizations?gov_type=municipal"
    json = JSON.parse(response.body)
    expect(json["results"].count).to eq(1)
  end

  it "gets the organizations with autonomous gov_type" do
    organization = FactoryGirl.create(:organization, title: "INEGI", gov_type: "autonomous")
    get "/api/v1/organizations?gov_type=autonomous"
    json = JSON.parse(response.body)
    expect(json["results"].count).to eq(1)
  end

  it "gets the organizations with autonomous gov_type" do
    organization = FactoryGirl.create(:organization, :sector)
    @sector = organization.sectors.first
    get "api/v1/organizations/?sector=#{@sector.slug}"
    json = JSON.parse(response.body)
    expect(json['results'].count).to eq(1)
  end
end
