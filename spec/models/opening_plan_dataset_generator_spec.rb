require 'spec_helper'

describe OpeningPlanDatasetGenerator do
  describe '#generate' do
    let!(:organization) { create(:organization) }
    let!(:inventory) { create(:inventory, organization: organization) }
    let!(:catalog) { create(:catalog_with_datasets, organization: organization) }

    before(:each) do
      OpeningPlanDatasetGenerator.new(inventory).generate
    end

    it 'should create a single dataset for the opening plan' do
      datasets = Dataset.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(datasets.size).to eq(1)
    end

    it 'should create single distribution for the opening plan dataset' do
      distributions = Distribution.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(distributions.size).to eq(1)
    end
  end
end
