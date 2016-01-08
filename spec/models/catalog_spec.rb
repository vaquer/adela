require 'spec_helper'

describe Catalog do
  shared_examples 'a valid catalog' do
    it 'should be valid' do
      expect(catalog).to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:catalog) { create(:catalog) }
    it_behaves_like 'a valid catalog'
  end
end
