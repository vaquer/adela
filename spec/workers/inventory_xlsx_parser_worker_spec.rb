require 'spec_helper'

describe InventoryXLSXParserWorker do
  it 'should parse the inventory spreadsheet file into inventory elements' do
    inventory = create(:inventory)
    InventoryXLSXParserWorker.new.perform(inventory.id)
    expect(inventory.inventory_elements.count).to be(3)
  end
end
