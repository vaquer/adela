require 'spec_helper'

describe InventoryXLSXParser do
  describe '#parse' do
    subject do
      InventoryXLSXParser.new(create(:inventory))
    end

    it 'parses the inventory rows from spreadsheet file' do
      expect(subject.parse.size).to eq(3)
    end

    it 'should have only valid rows' do
      expect(subject.parse.all?(&:valid?)).to eq(true)
    end

    it 'should have only compliant rows' do
      expect(subject.parse.all?(&:compliant?)).to eq(true)
    end
  end

  context 'inventory with yyyy-mm dates' do
    subject do
      spreadsheet_file = File.new("#{Rails.root}/spec/fixtures/files/inventory-issue-398.xlsx")
      InventoryXLSXParser.new(create(:inventory, spreadsheet_file: spreadsheet_file))
    end

    it 'should have only valid rows' do
      expect(subject.parse.all?(&:valid?)).to eq(true)
    end

    it 'should have only compliant rows' do
      expect(subject.parse.all?(&:compliant?)).to eq(true)
    end
  end
end
