require 'spec_helper'

describe OrganizationsController do
  let(:organization) { FactoryGirl.create(:organization) }

  describe "GET show" do
    it "has 200 status" do
      { :get => "/instituciones/#{organization.slug}.json" }
      expect(response.status).to eq(200)
    end
  end
end
