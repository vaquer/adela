require 'spec_helper'

describe Admin::UsersController do
  let(:admin) { create(:super_user) }

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
      user = FactoryGirl.create(:user)
      get :new, id: user.id
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end
  end

  describe 'GET edit' do
    before :each do
      user = FactoryGirl.create(:user)
      get :edit, id: user.id
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the edit template' do
      expect(response).to render_template('edit')
    end
  end

  describe 'GET edit_password' do
    before :each do
      user = FactoryGirl.create(:user)
      get :edit_password, id: user.id
    end

    it 'has 200 status' do
      expect(response.status).to eq(200)
    end

    it 'renders the edit_password template' do
      expect(response).to render_template('edit_password')
    end
  end

  describe 'POST create' do
    before :each do
      @email = Faker::Internet.email
      post :create, user: {
        name: Faker::Name.name,
        email: @email,
        organization_id: Organization.last.id
      }
    end

    it 'should create a new user' do
      user = User.find_by(email: @email)
      expect(user).not_to be_nil
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'PATCH update' do
    before :each do
      @user = FactoryGirl.create(:user)
      @new_name = Faker::Name.name
      @new_email = Faker::Internet.email
      @new_organization = FactoryGirl.create(
        :organization,
        title: Faker::Company.name
      )

      patch :update, id: @user.id, user: {
        name: @new_name,
        email: @new_email,
        organization_id: @new_organization
      }

      it 'should update user email' do
        expect(@user.email).to eq(@new_email)
      end

      it 'should update user name' do
        expect(@user.name).to eq(@new_name)
      end

      it 'should update user\'s organization' do
        expect(@user.organization.id).to eq(@new_organization.id)
      end

      it 'has 200 status' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET acting_as' do
    before :each do
      @user = FactoryGirl.create(:user)
      get :acting_as, id: @user.id
    end

    it 'stores original_user_id in session' do
      expect(session[:original_user_id]).to eql(admin.id)
    end

    it 'sets from_admin session value true' do
      expect(session[:from_admin]).to be_truthy
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET stop_acting_as" do
    before :each do
      @user = FactoryGirl.create(:user)
      get :acting_as, id: @user.id
      post :stop_acting
    end

    it 'sets from_admin session value false' do
      expect(session[:from_admin]).to be_falsey
    end

    it 'destroys original_user_id from session' do
      expect(session[:original_user_id]).to be_nil
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to admin_root_path' do
      expect(response).to redirect_to(admin_root_path)
    end
  end

  describe 'PUT grant_admin_role' do
    before :each do
      @user = FactoryGirl.create(:user)
      put :grant_admin_role, id: @user.id
    end

    it 'should grant admin role to an user' do
      expect(@user.has_role?(:admin)).to be true
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'PUT remove_admin_role' do
    before :each do
      @user = FactoryGirl.create(:user)
      @user.add_role(:admin)
      put :remove_admin_role, id: @user.id
    end

    it 'should remove admin role to an user' do
      expect(@user.has_role?(:admin)).to be false
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'PUT update_password' do
    before :each do
      @password = Faker::Internet.password
      @user = FactoryGirl.create(:user)
      put :update_password, id: @user.id, user: { password: @password, password_confirmation: @password }
    end

    it 'should update user\'s password' do
      user = User.find_by(email: @user.email)
      expect(user.valid_password?(@password)).to be true
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @user = FactoryGirl.create(:user)
      delete :destroy, id: @user.id
    end

    it 'should delete the user' do
      user = User.find_by(email: @user.email)
      expect(user).to be_nil
    end

    it 'has 302 status' do
      expect(response.status).to eq(302)
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
