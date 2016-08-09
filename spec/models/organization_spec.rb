require 'spec_helper'

describe Organization do
  context 'validations' do
    let(:organization) { create(:organization) }

    it 'should be valid with mandatory attributes' do
      expect(organization).to be_valid
    end

    it 'should be ranked by default' do
      expect(organization.ranked?).to be_truthy
    end

    it 'should not be valid without ranking flag' do
      organization.ranked = nil
      expect(organization).not_to be_valid
    end

    it 'should not be valid without a title' do
      organization.title = nil
      expect(organization).not_to be_valid
    end
  end

  context 'sector scope' do
    let(:organization) { create(:organization, :sector) }

    it 'should return the sector organizations' do
      slug = organization.sectors.first.slug
      organizations_count = Organization.sector(slug).count
      expect(organizations_count).to eq(1)
    end
  end
end
