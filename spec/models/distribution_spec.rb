require 'spec_helper'

describe Distribution do
  shared_examples 'a valid distribution' do
    it 'should be valid' do
      expect(distribution).to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:distribution) { create(:distribution) }
    it_behaves_like 'a valid distribution'
  end

  context 'with a duplicated download_url' do
    let(:distribution) { create(:distribution, download_url: Faker::Internet.url ) }

    it 'should not be valid' do
      invalid_distribution = build(:distribution, download_url: distribution.download_url )
      expect(invalid_distribution).not_to be_valid
    end
  end

  context 'after save' do
    let(:dataset) { create(:dataset, modified: Date.yesterday) }
    let(:distribution) { build(:distribution, dataset: dataset, modified: Date.today) }

    it 'should update the dataset modified with the latest distribution modified date' do
      distribution.save
      expect(dataset.modified).to eq(distribution.modified)
    end
  end
end
