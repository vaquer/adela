require 'spec_helper'

describe InventoryXLSXParser do
  describe '#parse' do
    subject do
      InventoryXLSXParser.new(create(:inventory))
    end

    it 'parses the inventory rows from spreadsheet file' do
      subject.parse.size.should == 3
    end

    it 'should have only valid rows' do
      subject.parse.all?(&:valid?).should == true
    end

    it 'should have only compliant rows' do
      subject.parse.all?(&:compliant?).should == true
    end
  end
end
