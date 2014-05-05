require 'spec_helper'

describe Organization do
  context 'validations' do
    before(:each) do
      @org = FactoryGirl.create(:organization)
    end

    it 'should be valid with mandatory attributes' do
      @org.should be_valid
    end

    it 'should not be valid without a title' do
      @org.title = nil
      @org.should_not be_valid
    end
  end
end