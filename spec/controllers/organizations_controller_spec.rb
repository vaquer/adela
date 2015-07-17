require 'spec_helper'

describe OrganizationsController do
  describe "GET opening_plan" do
    let(:organization) { FactoryGirl.create(:organization) }

    it "has 200 status" do
      { :get => "/#{organization.slug}/plan.json" }
      expect(response.status).to eq(200)
    end

    it "routes to organizations#opening_plan" do
      expect(:get => "/#{organization.slug}/plan.json").to route_to(
        :controller => "organizations",
        :action => "opening_plan",
        :slug   => organization.slug,
        :locale => "es",
        :format => "json",
      )
    end
  end
end
