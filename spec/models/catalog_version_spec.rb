require 'spec_helper'

RSpec.describe CatalogVersion, type: :model do
  context 'validations' do
    let(:catalog_version) { create(:catalog_version) }

    it 'should be valid ' do
      expect(catalog_version).to be_valid
    end

    it 'should not be valid without a version' do
      catalog_version.version = nil
      expect(catalog_version).not_to be_valid
    end

    it 'should not be valid without a catalog' do
      catalog_version.catalog = nil
      expect(catalog_version).not_to be_valid
    end
  end
end
