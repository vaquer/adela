require 'spec_helper'

describe HomeController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end

  describe "handling AccessDenied exceptions" do

    before :each do
      get :index
    end

    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end

    it "has 302 status" do
      expect(response.status).to eq(302)
    end

    it "shows access denied message" do
      expect(flash[:alert]).to eq(I18n.t("errors.messages.access_denied"))
    end
  end
end
