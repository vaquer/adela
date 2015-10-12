require 'spec_helper'

describe InventoryXLSXParserWorker do
  before(:each) do
    @inventory = create(:inventory)
    InventoryXLSXParserWorker.new.perform(@inventory.id)
  end

  it 'should parse the inventory spreadsheet file into inventory elements' do
    expect(@inventory.inventory_elements.count).to be(3)
  end

  it 'should generate the inventory dataset' do
    datasets = @inventory.organization.catalogs.last.datasets
    expect(datasets.count).to be(1)
  end
end
