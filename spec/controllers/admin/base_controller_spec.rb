require 'spec_helper'

describe Admin::BaseController do
  render_views

  let(:admin) { create(:super_user) }
  let(:user) { FactoryGirl.create(:user) }

  describe "GET index" do
    shared_examples "an authorized user" do
      before :each do
        init_time
        freeze_time(@admin_login_time)
        sign_in user
        get :index
      end

      after :each do
        Timecop.return
      end

      it "has 200 status" do
        expect(response.status).to eq(200)
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end

      it "stores login time in session" do
        expect(session[:admin_logs_in]).to eql(@admin_login_time)
      end

      it "expires admin session" do
        Timecop.travel(@admin_login_time + @seconds_to_expire_session)
        get :index
        expect(response).to redirect_to(new_user_session_es_path)
      end
    end

    context "as an admin" do
      it_behaves_like "an authorized user" do
        let(:user) { create(:super_user) }
      end
    end

    context "as an unpriviliged user" do
      before :each do
        sign_in user
        get :index
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

    def init_time
      @admin_login_time = Time.now
      @seconds_to_expire_session = 900.seconds
    end

    def freeze_time(time)
      Timecop.freeze(time)
    end
  end
end
