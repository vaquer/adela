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
end
