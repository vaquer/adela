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

    it 'should contain a dataset with an identifier containing the organization slug' do
      organization_slug = @catalog.organization.slug
      dataset_identifier = @catalog.datasets.last.identifier
      expected_identifier = "#{organization_slug}-plan-de-apertura-institucional"

      expect(dataset_identifier).to eql(expected_identifier)
    end

    it 'should contain a dataset containing the organization name in the title' do
      dataset_title = @catalog.datasets.last.title
      expected_title = "Plan de Apertura Institucional de #{@catalog.organization.title}"

      expect(dataset_title).to eql(expected_title)
    end
  end
end
