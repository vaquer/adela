require 'spec_helper'

describe DatasetSector do
  context 'with all mandatory fields' do
    let(:dataset_sector) { create(:dataset_sector) }
    it 'should be valid with all mandatory fields' do
      expect(dataset_sector).to be_valid
    end
  end
end
