require 'spec_helper'

describe User do
  context 'validations' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should be valid with mandatory attributes' do
      expect(@user).to be_valid
    end

    it 'should not be valid without email' do
      @user.email = nil
      expect(@user).not_to be_valid
    end

    it 'should not be valid without name' do
      @user.name = nil
      expect(@user).not_to be_valid
    end

    it 'should not be valid with a short password' do
      @user.password = "short"
      @user.password_confirmation = "short"
      expect(@user).not_to be_valid
    end
  end
end
