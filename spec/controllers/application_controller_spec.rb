require 'spec_helper'

describe ApplicationController do
  describe 'current_catalog helper' do
    before(:each) do
      @organization = create(:organization)
      @user = create(:user, organization: @organization)
      sign_in(@user)
    end

    context 'an organization with a published catalog' do
      before(:each) do
        create(:catalog, :datasets, organization: @organization)
        create(:catalog, :unpublished, :datasets, organization: @organization)
        @current_catalog = create(:catalog, :datasets, organization: @organization)
      end

      it 'should return the current catalog' do
        expect(controller.send(:current_catalog)).to eql(@current_catalog)
      end
    end

    context 'an organization without a published catalog' do
      before(:each) do
        create(:catalog, :unpublished, :datasets, organization: @organization)
      end

      it 'should return nil' do
        expect(controller.send(:current_catalog)).to be_nil
      end
    end
  end
end
