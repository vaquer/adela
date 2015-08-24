require 'spec_helper'

describe Inventory do
  context 'with all mandatory fields' do
    let(:inventory) { build_stubbed(:inventory) }

    it 'should be valid ' do
      inventory.should be_valid
    end
  end

  context 'without an spreadsheet file' do
    let(:inventory) { build_stubbed(:inventory, spreadsheet_file: nil) }

    it 'should not be valid ' do
      inventory.should_not be_valid
    end
  end

  context 'without an spreadsheet file' do
    let(:inventory) { build_stubbed(:inventory, organization: nil) }

    it 'should not be valid ' do
      inventory.should_not be_valid
    end
  end
end
