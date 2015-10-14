require 'spec_helper'

describe DistributionsHelper do
  describe '#edit_link_to_text' do
    it 'returns the \'update\' string' do
      distribution = create(:distribution)
      text = helper.edit_link_to_text(distribution)
      expect(text).to eq('Actualizar')
    end

    it 'returns the \'needs info\' legend' do
      distribution = create(:distribution, :unpublished)
      text = helper.edit_link_to_text(distribution)
      expect(text).to eq('Completar')
    end
  end
end
