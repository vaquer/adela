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

  context 'sector scope' do
    before(:each) do
      @organization = FactoryGirl.create(:organization, :sector)
    end

    it 'should return the sector organizations' do
      slug = Sector.last.slug
      organizations_count = Organization.sector(slug).count
      expect(organizations_count).to eq(1)
    end
  end
end
