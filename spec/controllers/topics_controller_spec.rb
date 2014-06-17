require 'spec_helper'

describe TopicsController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe "POST create" do
    it "creates a new topic" do
      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner", :publish_date => DateTime.now }, :format => "json"
      assigns(:topic).should be_persisted
    end

    it "assigns the topic to the current organization" do
      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner", :publish_date => DateTime.now }, :format => "json"
      assigns(:topic).organization.should == user.organization
    end

    it "assigns a sort_order" do
      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner", :publish_date => DateTime.now }, :format => "json"
      assigns(:topic).sort_order.should == 1

      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner", :publish_date => DateTime.now }, :format => "json"
      assigns(:topic).sort_order.should == 2

      xhr :post, :create, :topic => { :name => "Name", :owner => "Owner", :publish_date => DateTime.now }, :format => "json"
      assigns(:topic).sort_order.should == 3
    end

    it "responds with a json encoded topic" do
      post_data = { :name => "The name", :owner => "The owner",
                    :description => "The description", :publish_date => DateTime.now}
      formatted_publish_date = I18n.l(DateTime.now, :format => :short)

      xhr :post, :create, :topic => post_data, :format => "json"

      topic = JSON.parse(response.body)
      topic["name"].should == post_data[:name]
      topic["owner"].should == post_data[:owner]
      topic["description"].should == post_data[:description]
      Date.parse(topic["publish_date"]).should == post_data[:publish_date].to_date
    end
  end

  describe "PATCH update" do
    let(:organization) { user.organization }
    let(:topic) { organization.topics.create!(FactoryGirl.attributes_for(:topic)) }
    let(:data) do
      {
        :name => "Edited name", :owner => "Edited owner",
        :description => "Edited description",
        :publish_date => DateTime.tomorrow
      }
    end

    it "updates the topic" do
      xhr :patch, :update, { :id => topic.id, :topic => data }, :format => "json"

      topic.reload
      topic.name.should == "Edited name"
      topic.owner.should == "Edited owner"
      topic.description.should == "Edited description"
      topic.publish_date.should == DateTime.tomorrow.to_date
    end

    it "responds with a json encoded topic" do
      xhr :patch, :update, { :id => topic.id, :topic => data }, :format => "json"

      topic = JSON.parse(response.body)
      topic["name"].should == "Edited name"
      topic["owner"].should == "Edited owner"
      topic["description"].should == "Edited description"
      Date.parse(topic["publish_date"]).should == DateTime.tomorrow.to_date
    end
  end
end
