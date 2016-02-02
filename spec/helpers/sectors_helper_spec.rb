require 'spec_helper'

describe SectorsHelper do
  before(:each) do
    @foo_sector = create(:sector, title: 'foo')
    @bar_sector = create(:sector, title: 'bar')
  end

  describe '#options_for_sectors_select' do
    it 'returns a collection of sectors' do
      array = helper.options_for_sectors_select
      expect(array).to eq([['foo', @foo_sector.id], ['bar', @bar_sector.id]])
    end
  end
end
