require 'spec_helper'

describe CatalogDatasetsGenerator do
  before(:each) do
    @distributions_count = Faker::Number.between(1, 5)
    @organization = create(:organization, :catalog, :opening_plan, distributions_count: @distributions_count)
    CatalogDatasetsGenerator.new(@organization).execute
  end

  describe '#execute' do
    it 'should generate a dataset for each opening plan entry' do
      datasets = @organization.catalog.datasets
      expect(datasets.count).to eq(@organization.opening_plans.count)
    end

    it 'should generate all distributions' do
      @organization.catalog.datasets.each do |dataset|
        expect(dataset.distributions.count).to eq(@distributions_count)
      end
    end
  end
end
