require 'spec_helper'

describe Inventory do
  context "validations" do
    before(:each) do
      @inventory = FactoryGirl.create(:inventory)
    end

    shared_examples "an invalid inventory file" do
      before(:each) do
        @inventory.csv_file = File.new(csv_file)
      end

      it "should not be valid with an invalid file" do
        @inventory.should_not be_valid
      end
    end

    context "blank file" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/invalid_file.txt" }
      end
    end

    context "file with ragged rows" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/ragged_rows_inventory.csv" }
      end
    end

    context "file with a blank row" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_inventory.csv" }
      end
    end

    context "file with a row with all fields in blank" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_inventory-2.csv" }
      end
    end

    context "file with stray quotes" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/stray_quote_inventory.csv" }
      end
    end

    context "file with a quoted column has leading or trailing whitespace" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/whitespace_inventory.csv" }
      end
    end

    it "should be valid with mandatory fields" do
      @inventory.should be_valid
    end

    it "should not be valid without an organization" do
      @inventory.organization_id = nil
      @inventory.should_not be_valid
    end
  end
end
