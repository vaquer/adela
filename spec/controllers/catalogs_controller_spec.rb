require 'spec_helper'

describe CatalogsController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe "POST create" do

    shared_examples "a valid catalog file" do
      it "creates a new catalog" do
        post :create, catalog: { csv_file: catalog_file }, :locale => "es"
        assigns(:catalog).should be_kind_of(Catalog)
        assigns(:catalog).should be_persisted
      end

      it "assigns the catalog to the current organization" do
        post :create, catalog: { csv_file: catalog_file }, :locale => "es"
        assigns(:catalog).organization.should == user.organization
      end

      it "redirects to new catalog page" do
        post :create, catalog: { csv_file: catalog_file }, :locale => "es"
        response.should render_template("new")
      end
    end

    context "UTF-8 file" do
      it_behaves_like "a valid catalog file" do
        let(:catalog_file) { fixture_file_upload("files/catalog.csv") }
      end
    end

    context "ISO 8859-1 file" do
      it_behaves_like "a valid catalog file" do
        let(:catalog_file) { fixture_file_upload("files/catalog-latin-1.csv") }
      end
    end

    shared_examples "an invalid catalog file" do
      it "redirects to catalogs_path" do
        post :create, catalog: { csv_file: "" }, :locale => "es"
        expect(response).to redirect_to(catalogs_path)
      end

      it "has 302 status" do
        post :create, catalog: { csv_file: "" }, :locale => "es"
        expect(response.status).to eq(302)
      end

      it "shows invalid encoding message" do
        post :create, catalog: { csv_file: "" }, :locale => "es"
        expect(flash[:alert]).to eq(error_message)
      end

      it "raises Exceptions::UnknownEncodingError" do
        bypass_rescue
        expect { post :create, catalog: { csv_file: "" }, :locale => "es" }.to raise_error
      end
    end

    context "file with invalid encoding" do
      before do
        def controller.create
          raise Exceptions::UnknownEncodingError
        end
      end
      it_behaves_like "an invalid catalog file" do
        let(:error_message) { I18n.t("activerecord.errors.models.catalog.attributes.csv_file.encoding") }
      end
    end

    context "malformed csv file" do
      before do
        def controller.create
          raise CSV::MalformedCSVError
        end
      end
      it_behaves_like "an invalid catalog file" do
        let(:error_message) { I18n.t("activerecord.errors.models.catalog.attributes.csv_file.malformed") }
      end
    end

    context "empty catalog file" do
      it "renders the template again on error" do
        post :create, catalog: { csv_file: "" }, :locale => "es"
        response.should render_template("new")
      end
    end
  end
end
