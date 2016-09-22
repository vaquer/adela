require 'spec_helper'

describe Sector do
  let(:sector) { create(:sector) }

  context 'validations' do
    it 'should be valid with all mandatory fields' do
      expect(sector).to be_valid
    end

    it 'should not be valid without a title' do
      sector.title = nil
      expect(sector).not_to be_valid
    end
  end

  context 'friendly_id' do
    it 'should have an slug' do
      expect(sector.slug).not_to be_nil
    end
  end
end
