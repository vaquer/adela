require 'spec_helper'

describe OpeningPlanDatasetGenerator do
  describe '#generate' do
    context 'a new inventory' do
      let(:organization) { create(:organization) }
      let(:inventory) { create(:inventory, organization: organization) }

      before(:each) do
        OpeningPlanDatasetGenerator.new(inventory).generate
      end

      it 'should create an organization catalog' do
        expect(organization.catalog).not_to be_nil
      end

      it 'should create a dataset' do
        expect(organization.catalog.datasets.count).to eql(1)
      end

      it 'should create a dataset with one distribution' do
        dataset = organization.catalog.datasets.last
        expect(dataset.distributions.count).to eql(1)
      end

      it 'should contain a dataset with the organization name in the title' do
        dataset_title = organization.catalog.datasets.last.title
        expected_title = "Plan de Apertura Institucional de #{organization.title}"

        expect(dataset_title).to eql(expected_title)
      end

      it 'should contain a distribution with the organization name in the title' do
        distribution_title = organization.catalog.datasets.last.distributions.last.title
        expected_title = "Plan de Apertura Institucional de #{organization.title}"

        expect(distribution_title).to eql(expected_title)
      end

      it 'should contain an identifier with the organization slug' do
        organization_slug = organization.title.to_slug.normalize.to_s
        dataset_identifier = organization.catalog.datasets.last.identifier
        expected_identifier = "plan-de-apertura-institucional-de-#{organization_slug}"

        expect(dataset_identifier).to eql(expected_identifier)
      end

      it 'should set the modified field for the distribution' do
        dataset       = organization.catalog.datasets.last
        distribution  = dataset.distributions.last
        expect(distribution.modified).to eq(dataset.modified)
      end

      it 'should set a temporal range for the distributions' do
        dataset       = organization.catalog.datasets.last
        distribution  = dataset.distributions.last
        timestring    = "P3H33M/#{dataset.modified.strftime("%FT%T%:z")}"
        expect(distribution.temporal).to eq(timestring)
      end
    end

    context 'an existing inventory' do
      before(:each) do
        @organization = create(:organization)
        old_inventory = create(:inventory, organization: @organization)
        InventoryDatasetsWorker.new.perform(old_inventory.id)

        @old_dataset = @organization.catalog.datasets.first.deep_clone(include: [:distributions])

        Timecop.travel(Faker::Date.forward)

        new_inventory = create(:inventory, organization: @organization)
        OpeningPlanDatasetGenerator.new(new_inventory).generate
        @new_dataset = @organization.catalog.datasets.first.deep_clone(include: [:distributions])
      end

      after(:each) do
        Timecop.return
      end

      it 'should not create a new dataset' do
        expect(@organization.catalog.non_editable_datasets.count).to eq(1)
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

      it 'should update temporal range for the existing distribution' do
        resource    = @new_dataset.distributions.first
        timestring  = "P3H33M/#{resource.modified.strftime("%FT%T%:z")}"
        expect(resource.temporal).to eq(timestring)
      end
    end
  end
end
