require 'spec_helper'

describe TopicsController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe "POST create" do
    it "creates a new topic" do
      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner" }, format: "json"
      assigns(:topic).should be_persisted
    end

    it "assigns the topic to the current organization" do
      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner" }, format: "json"
      assigns(:topic).organization.should == user.organization
    end

    it "assigns a sort_order"

    it "responds with a json encoded topic" do
      post_data = { :name => "The name", :owner => "The owner",
                    :description => "The description" }

      xhr :post, :create, :topic => post_data, format: "json"

      topic = JSON.parse(response.body)
      topic["name"].should == post_data[:name]
      topic["owner"].should == post_data[:owner]
      topic["description"].should == post_data[:description]
    end
  end
end
