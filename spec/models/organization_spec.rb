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

  context '#current_catalog' do
    before(:each) do
      @organization = create(:organization)
    end

    it 'should return the last published catalog' do
      create(:catalog, organization: @organization)
      create(:catalog, :unpublished, organization: @organization)
      current_catalog = create(:catalog, organization: @organization, publish_date: Time.now)
      @organization.current_catalog.should be_eql(current_catalog)
    end

    it 'should return nil when there are no published catalogs' do
      create(:catalog, :unpublished, organization: @organization)
      @organization.current_catalog.should be_nil
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
