require 'spec_helper'

describe DistributionsHelper do
  describe '#edit_link_to_text' do
    it 'returns the \'update\' string' do
      distribution = build(:distribution, :published)
      text = helper.edit_link_to_text(distribution)
      expect(text).to eq('Actualizar')
    end

    it 'returns the \'needs info\' legend' do
      distribution = build(:distribution, :broke)
      text = helper.edit_link_to_text(distribution)
      expect(text).to eq('Completar')
    end
  end

  describe '#state_description' do
    it 'shows the broke description' do
      distribution = build(:distribution, :broke)
      text = helper.state_description(distribution)
      expect(text).to eq('Falta información')
    end

    it 'shows the validated description' do
      distribution = build(:distribution, :validated)
      text = helper.state_description(distribution)
      expect(text).to eq('Listo para publicar')
    end

    it 'shows the published description' do
      distribution = build(:distribution, :published)
      text = helper.state_description(distribution)
      expect(text).to eq('Publicado')
    end
  end
end
