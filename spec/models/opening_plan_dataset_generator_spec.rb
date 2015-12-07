require 'spec_helper'

describe OpeningPlanDatasetGenerator do
  describe '#generate' do
    let(:catalog) { create(:catalog) }

    before(:each) do
      OpeningPlanDatasetGenerator.new(catalog).generate
    end

    context 'with a new opening plan' do
      it 'should generate a dataset' do
        expect(catalog.datasets.count).to eql(1)
      end

      it 'should generate a dataset with one distribution' do
        dataset = catalog.datasets.last
        expect(dataset.distributions.count).to eql(1)
      end

      it 'should generate a dataset with a validated distribution' do
        dataset = catalog.datasets.last
        distribution = dataset.distributions.last
        expect(distribution.state).to eql('validated')
      end

      it 'should contain a dataset with an identifier containing the organization slug' do
        organization_slug = catalog.organization.slug
        dataset_identifier = catalog.datasets.last.identifier
        expected_identifier = "#{organization_slug}-plan-de-apertura-institucional"

        expect(dataset_identifier).to eql(expected_identifier)
      end

      it 'should contain a dataset containing the organization name in the title' do
        dataset_title = catalog.datasets.last.title
        expected_title = "Plan de Apertura Institucional de #{catalog.organization.title}"

        expect(dataset_title).to eql(expected_title)
      end

      it 'should contain a distribution containing the organization name in the title' do
        distribution_title = catalog.datasets.last.distributions.last.title
        expected_title = "Plan de Apertura Institucional de #{catalog.organization.title}"

        expect(distribution_title).to eql(expected_title)
      end
    end

    context 'updating an existing opening plan' do
      before(:each) do
        @old_dataset = catalog.datasets.first.deep_clone(include: [:distributions])
        Timecop.travel(Faker::Date.forward)
        OpeningPlanDatasetGenerator.new(catalog).generate
        @new_dataset = catalog.datasets.first.deep_clone(include: [:distributions])
      end

      after(:each) do
        Timecop.return
      end

      it 'should not create a new dataset' do
        expect(catalog.datasets.count).to eql(1)
      end

      it 'should update the modified field from the existing dataset' do
        old_dataset_modified = @old_dataset.modified
        new_dataset_modified = @new_dataset.modified
        expect(new_dataset_modified).to be > old_dataset_modified
      end

      it 'should update the modified field from the existing distribution' do
        old_distribution_modified = @old_dataset.distributions.first.modified
        new_distribution_modified = @new_dataset.distributions.first.modified
        expect(new_distribution_modified).not_to eql(old_distribution_modified)
      end
    end
  end
end
