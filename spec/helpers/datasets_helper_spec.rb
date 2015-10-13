require 'spec_helper'

describe DatasetsHelper do
  describe '#published_distributions_percentage' do

    before(:each) do
      @dataset = FactoryGirl.create(:dataset)
    end

    it 'returns percentage of published distributions' do

      FactoryGirl.create(:distribution, dataset: @dataset)
      FactoryGirl.create(:distribution, :unpublished, dataset: @dataset)
      percentage = helper.published_distributions_percentage(@dataset)
      expect(percentage).to eq(50)
    end

    it 'returns 0 when dataset has no distributions' do
      percentage = helper.published_distributions_percentage(@dataset)
      expect(percentage).to eq(0)
    end
  end
end
