require 'spec_helper'

describe InventoriesController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe "POST create" do
    let(:inventory_file) { fixture_file_upload("files/inventory.csv") }

    it "creates a new inventory" do
      post :create, inventory: { csv_file: inventory_file }
      assigns(:inventory).should be_kind_of(Inventory)
      assigns(:inventory).should be_persisted
    end

    it "assigns the inventory to the current organization" do
      post :create, inventory: { csv_file: inventory_file }
      assigns(:inventory).organization.should == user.organization
    end

    it "redirects to new inventory page" do
      post :create, inventory: { csv_file: inventory_file }
      response.should render_template("new")
    end

    it "renders the template again on error" do
      post :create, inventory: { csv_file: "" }
      response.should render_template("new")
    end
  end
end
