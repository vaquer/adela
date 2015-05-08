require 'spec_helper'

describe InventoriesController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe "POST create" do

    shared_examples "a valid inventory file" do
      it "creates a new inventory" do
        post :create, inventory: { csv_file: inventory_file }, :locale => "es"
        assigns(:inventory).should be_kind_of(Inventory)
        assigns(:inventory).should be_persisted
      end

      it "assigns the inventory to the current organization" do
        post :create, inventory: { csv_file: inventory_file }, :locale => "es"
        assigns(:inventory).organization.should == user.organization
      end

      it "redirects to new inventory page" do
        post :create, inventory: { csv_file: inventory_file }, :locale => "es"
        response.should render_template("new")
      end
    end

    context "UTF-8 file" do
      it_behaves_like "a valid inventory file" do
        let(:inventory_file) { fixture_file_upload("files/inventory.csv") }
      end
    end

    context "ISO 8859-1 file" do
      it_behaves_like "a valid inventory file" do
        let(:inventory_file) { fixture_file_upload("files/inventory-latin-1.csv") }
      end
    end

    context "file with invalid encoding" do
      before do
        def controller.create
          raise Exceptions::UnknownEncodingError
        end
      end

      it "redirects to inventories_path" do
        post :create, inventory: { csv_file: "" }, :locale => "es"
        expect(response).to redirect_to(inventories_path)
      end

      it "has 302 status" do
        post :create, inventory: { csv_file: "" }, :locale => "es"
        expect(response.status).to eq(302)
      end

      it "shows invalid encoding message" do
        post :create, inventory: { csv_file: "" }, :locale => "es"
        expect(flash[:alert]).to eq(I18n.t("activerecord.errors.models.inventory.attributes.csv_file.encoding"))
      end

      it "raises Exceptions::UnknownEncodingError" do
        bypass_rescue
        expect { post :create, inventory: { csv_file: "" }, :locale => "es" }.to raise_error(Exceptions::UnknownEncodingError)
      end
    end

    context "empty inventory file" do
      it "renders the template again on error" do
        post :create, inventory: { csv_file: "" }, :locale => "es"
        response.should render_template("new")
      end
    end
  end
end
