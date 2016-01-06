require 'spec_helper'

describe Sector do
  context 'with all mandatory fields' do
    let(:sector) { create(:sector) }
    it 'should be valid with all mandatory fields' do
      expect(sector).to be_valid
    end
  end

  context 'without a title' do
    let(:sector) { build(:sector, title: nil) }
    it 'should not be valid ' do
      expect(sector).not_to be_valid
    end
  end
end
