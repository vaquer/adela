require 'spec_helper'

describe Inventory do
  shared_examples 'a valid inventory' do
    it 'should be valid' do
      expect(inventory).to be_valid
    end
  end

  shared_examples 'an invalid inventory' do
    it 'should not be valid ' do
      expect(inventory).not_to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:inventory) { build_stubbed(:inventory) }
    it_behaves_like 'a valid inventory'
  end

  context 'without an organization' do
    let(:inventory) { build_stubbed(:inventory, organization: nil) }
    it_behaves_like 'an invalid inventory'
  end
end
