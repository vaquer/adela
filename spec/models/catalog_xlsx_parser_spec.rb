require 'spec_helper'

describe CatalogXLSXParser do
  let(:organization) { create(:organization) }
  let(:inventory) { create(:inventory, organization: organization) }

  subject(:parser) { CatalogXLSXParser.new(inventory) }

  context '#parse' do
    before(:each) do
      subject.parse
    end

    it 'should create an organization catalog' do
      expect(organization.catalog).not_to be_nil
    end

    it 'should create datasets from the inventory spreadsheet file' do
      datasets = organization.catalog.datasets
      expect(datasets.count).to eq(1)
    end

    it 'should create distributions from the inventory spreadsheet file' do
      distributions = organization.catalog.datasets.first.distributions
      expect(distributions.count).to eq(1)
    end
  end
end
