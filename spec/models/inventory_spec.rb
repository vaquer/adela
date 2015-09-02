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

  context 'after saving an inventory' do
    let(:inventory) { create(:inventory) }

    it 'should be an InventoryXLSXParserWorker enqueued job' do
      expect(InventoryXLSXParserWorker).to have_enqueued_job(inventory.id)
    end
  end
end
