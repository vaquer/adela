require 'spec_helper'

describe Dataset do
  shared_examples 'a valid dataset' do
    it 'should be valid ' do
      dataset.should be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:dataset) { create(:dataset) }
    it_behaves_like 'a valid dataset'
  end

  context '#publisher' do
    it 'should be equal to the organization title' do
      dataset = create(:dataset)
      organization = dataset.catalog.organization.title
      expect(dataset.publisher).to eql(organization)
    end
  end

  context '#keywords' do
    it 'should include the dataset keyword' do
      dataset = create(:dataset)
      expect(dataset.keywords).to include(dataset.keyword)
    end

    it 'should include the organization sectors' do
      organization = create(:organization, :sector)
      dataset = create(:dataset)
      dataset.catalog.organization = organization

      expect(dataset.keywords).to include(organization.sectors.first.slug)
    end
  end

  context '#sectors' do
    it 'should include the organization sectors slug' do
      organization = create(:organization, :sector)
      dataset = create(:dataset)
      dataset.catalog.organization = organization

      sectors = dataset.send(:sectors)
      expect(sectors).to include(organization.sectors.first.slug)
    end
  end
end
