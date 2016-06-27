require 'spec_helper'

describe Admin::OrganizationsController do
  let(:admin) { FactoryGirl.create(:admin) }

  before :each do
    sign_in admin
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET new' do
    before :each do
      get :new
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end
  end

  describe 'POST create' do
    before :each do
      @attributes = FactoryGirl.attributes_for(:organization, :federal)
      post :create, organization: @attributes
    end

    it 'should create a new organization' do
      organization = Organization.find_by(title: @attributes[:title])
      expect(organization).not_to be_nil
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_organizations_path)
    end
  end

  describe 'GET edit' do
    before :each do
      get :edit, id: FactoryGirl.create(:organization).id
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the edit template' do
      expect(response).to render_template('edit')
    end
  end

  describe 'PATCH update' do
    before :each do
      @organization = FactoryGirl.create(:organization)
      @attributes = FactoryGirl.attributes_for(:organization, :federal)
      @organization.reload

      patch :update, id: @organization.id, organization: @attributes

      it 'should update organization title' do
        expect(@organization.title).to eq(@attributes[:title])
      end

      it 'should update organization description' do
        expect(@organization.description).to eq(@attributes[:description])
      end

      it 'should update organization gov_type' do
        expect(@organization.gov_type).to eq(@attributes[:gov_type])
      end

      it 'has 200 status' do
        expect(response.status).to eq(200)
      end
    end
  end
end
