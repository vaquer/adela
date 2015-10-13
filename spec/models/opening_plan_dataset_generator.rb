require 'spec_helper'

describe OpeningPlanDatasetGenerator do
  before(:each) do
    @catalog = create(:catalog)
  end

  describe '#generate' do
    before(:each) do
      OpeningPlanDatasetGenerator.new(@catalog).generate
    end

    it 'should generate a dataset' do
      expect(@catalog.datasets.count).to eql(1)
    end

    it 'should generate a dataset with one distribution' do
      dataset = @catalog.datasets.last
      expect(dataset.distributions.count).to eql(1)
    end
  end
end
