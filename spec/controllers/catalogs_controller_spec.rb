require 'spec_helper'

describe CatalogsController do
  describe 'GET #index' do
    context 'with an opening plan and inventory' do
      before(:each) do
        @organization = create(:organization, :catalog, :opening_plan)
        @user = create(:user, organization: @organization)
        sign_in(@user)

        get :index, organization_id: @organization.id, locale: :es
      end

      it 'has 302 status' do
        expect(response.status).to eq(302)
      end

      it 'redirects to catalog_datasets path' do
        expect(response).to redirect_to(catalog_datasets_path(@organization.catalog))
      end
    end

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
        @organization = create(:organization, :catalog)
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

  describe 'PUTS #publish' do
    before { ActionMailer::Base.deliveries = [] }

    before(:each) do
      @organization = create(:organization, :catalog, :opening_plan)
      @user = create(:user, :administrator, organization: @organization)
      distribution_ids = @organization.catalog.distributions.map(&:id)
      sign_in(@user)

      put :publish, id: @organization.id, catalog: { distribution_ids: distribution_ids }, locale: :es
    end

    it 'sends an email to administrator' do
      deliveries_count = ActionMailer::Base.deliveries.count
      expect(deliveries_count).to eq(1)
    end

    it 'enqueues the harvest job' do
      catalog_url = "http://adela.datos.gob.mx/#{@organization.slug}/catalogo.json"
      expect(ShogunHarvestWorker).to have_enqueued_job(catalog_url)
    end
  end
end
