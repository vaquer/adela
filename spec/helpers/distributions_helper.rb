require 'spec_helper'

describe DistributionsHelper do
  describe '#state_description' do
    it 'shows the broke description' do
      distribution = build(:distribution, :broke)
      text = helper.state_description(distribution)
      expect(text).to eq('Falta información')
    end

    it 'shows the documented description' do
      distribution = build(:distribution, :documented)
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
