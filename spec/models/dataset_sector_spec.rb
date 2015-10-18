require 'spec_helper'

describe DatasetSector do
  context 'with all mandatory fields' do
    let(:dataset_sector) { create(:dataset_sector) }
    it 'should be valid with all mandatory fields' do
      dataset_sector.should be_valid
    end
  end
end
