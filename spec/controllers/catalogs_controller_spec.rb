require 'spec_helper'

describe CatalogsController do
  describe 'GET #index' do
    context 'without an inventory' do
      before(:each) do
        @organization = create(:organization)
        @user = create(:user, organization: @organization)
        sign_in(@user)

        get :index, organization_id: @organization.id, locale: :es
      end

      it 'has 200 status' do
        expect(response.status).to eq(200)
      end

      it 'renders error template' do
        expect(response).to render_template(:error)
      end
    end

    context 'without an opening plan' do
      before(:each) do
        @organization = create(:organization)
        create(:inventory, organization: @organization)
        @user = create(:user, organization: @organization)
        sign_in(@user)

        get :index, organization_id: @organization.id, locale: :es
      end

      it 'has 200 status' do
        expect(response.status).to eq(200)
      end

      it 'renders error template' do
        expect(response).to render_template(:error)
      end
    end

    context 'when user is logged out' do
      before(:each) do
        @organization = create(:organization)
        @user = create(:user, organization: @organization)
        get :index, organization_id: @organization.id, locale: :es
      end

      it 'has 302 status' do
        expect(response.status).to eq(302)
      end

      it 'redirects to new_user_session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
