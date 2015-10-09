require 'spec_helper'

describe InventoryDatasetGenerator do
  before(:each) do
    @inventory = create(:inventory, :elements)
  end

  describe '#generate' do
    before(:each) do
      InventoryDatasetGenerator.new(@inventory).generate
    end

    it 'should generate an organization catalog' do
      organization = @inventory.organization
      expect(organization.catalogs.count).to eql(1)
    end

    it 'should generate a dataset' do
      catalog = @inventory.organization.catalogs.last
      expect(catalog.datasets.count).to eql(1)
    end

    it 'should generate a dataset with one distribution' do
      catalog = @inventory.organization.catalogs.last
      dataset = catalog.datasets.last
      expect(dataset.distributions.count).to eql(1)
    end
  end
end
