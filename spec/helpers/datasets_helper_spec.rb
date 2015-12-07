require 'spec_helper'

describe DatasetsHelper do
  describe '#accrual_periodicity_translate' do
    it 'translates the accrual periodicity values' do
      ISO8601_DEFAULTS['accrual_periodicity'].each do |key, value|
        accrual_periodicity = helper.accrual_periodicity_translate(value)
        expect(accrual_periodicity).to eq(key)
      end
    end
  end

  describe '#documented_distributions' do
    it 'returns only documented distributions' do
      dataset = create(:dataset)
      create(:distribution, :broke, dataset: dataset)
      create(:distribution, :validated, dataset: dataset)
      create(:distribution, :published, dataset: dataset)
      dataset.reload

      distributions = helper.documented_distributions(dataset)
      expect(distributions.count).to eq(2)
    end
  end

  describe '#next_dataset' do
    let(:catalog) { create(:catalog, :datasets, datasets_count: 2) }

    it 'should return the next dataset' do
      helper.stub(:current_organization) { catalog.organization }
      current_dataset = catalog.datasets.sort_by(&:publish_date).first
      next_dataset = catalog.datasets.last
      next_dataset = helper.next_dataset(current_dataset)

      expect(next_dataset).to eql(next_dataset)
    end

    it 'should return nil on the last dataset' do
      helper.stub(:current_organization) { catalog.organization }
      current_dataset = catalog.datasets.sort_by(&:publish_date).last
      next_dataset = helper.next_dataset(current_dataset)

      expect(next_dataset).to be_nil
    end
  end
end
