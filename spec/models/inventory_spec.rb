require 'spec_helper'

describe Inventory do
  context 'valid inventories' do
    before(:each) do
      @inventory = FactoryGirl.create(:inventory)
    end

    it 'should be valid with mandatory fields' do
      @inventory.should be_valid
    end

    it 'should not be valid without an organization' do
      @inventory.organization_id = nil
      @inventory.should_not be_valid
    end

    it 'should contain valid datasets' do
      @inventory.has_valid_datasets?.should be_true
    end
  end

  context 'invalid inventories' do
    shared_examples 'an invalid inventory file' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.build(:inventory, csv_file: file)
      end

      it "should not be valid with an invalid file" do
        @inventory.should_not be_valid
      end
    end

    shared_examples 'an inventory with invalid datasets' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.build(:inventory, csv_file: file)
      end

      it "should contain valid datasets" do
        @inventory.has_valid_datasets?.should be_false
      end
    end

    context "an inventory with non alphanumeric keywords in dataset" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-non-alphanumeric.csv" }
      end

      it_behaves_like "an inventory with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-non-alphanumeric.csv" }
      end
    end

    context "an inventory file with a null download url" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-null-download-url.csv" }
      end

      it_behaves_like "an inventory with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-null-download-url.csv" }
      end
    end

    context "inventory with duplicated titles in datasets" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-with-duplicated-title.csv" }
      end
    end

    context "inventory with duplicated identifiers in datasets" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-with-duplicated-identifiers.csv" }
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
  end
end
