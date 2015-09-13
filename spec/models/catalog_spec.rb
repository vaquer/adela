require 'spec_helper'

describe Catalog do

  context 'valid catalogs' do

    shared_examples 'a valid catalog file' do
      before(:each) do
        file = File.new(csv_file)
        @catalog = FactoryGirl.create(:catalog, csv_file: file)
      end

      it 'should be valid with mandatory fields' do
        @catalog.should be_valid
      end

      it 'should not be valid without an organization' do
        @catalog.organization_id = nil
        @catalog.should_not be_valid
      end

      it 'should contain valid datasets' do
        @catalog.has_valid_datasets?.should be_true
      end
    end

    it_behaves_like 'a valid catalog file' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog.csv" }
    end

    it_behaves_like 'a valid catalog file' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-v3.csv" }
    end
  end

  context 'compliant catalogs' do
    shared_examples 'a compliant catalog' do
      before(:each) do
        file = File.new(csv_file)
        @catalog = FactoryGirl.create(:catalog, csv_file: file)
      end

      it 'should be valid' do
        @catalog.should be_valid
      end

      it 'should be compliant' do
        @catalog.compliant?.should be true
      end
    end

    it_behaves_like 'a compliant catalog' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-accrual-periodicity.csv" }
    end
  end

  context 'noncompliant catalogs' do
    before(:each) do
      file = File.new("#{Rails.root}/spec/fixtures/files/catalog-noncompliant.csv")
      @catalog = FactoryGirl.create(:catalog, csv_file: file)
    end

    it 'should be valid' do
      @catalog.should be_valid
    end

    it 'should be compliant' do
      @catalog.compliant?.should be false
    end
  end

  context 'invalid catalogs' do
    shared_examples 'an invalid catalog file' do
      before(:each) do
        file = File.new(csv_file)
        @catalog = FactoryGirl.build(:catalog, csv_file: file)
      end

      it "should not be valid with an invalid file" do
        @catalog.should_not be_valid
      end
    end

    shared_examples 'an catalog with invalid datasets' do
      before(:each) do
        file = File.new(csv_file)
        @catalog = FactoryGirl.build(:catalog, csv_file: file)
      end

      it "should contain valid datasets" do
        @catalog.has_valid_datasets?.should be_false
      end
    end

    context 'an catalog with invalid landing page' do

      it_behaves_like 'an catalog with invalid datasets' do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-v3-invalid-landing-page.csv" }
      end

      it_behaves_like 'an catalog with invalid datasets' do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-v3-blank-landing-page.csv" }
      end
    end

    context "an catalog with non alphanumeric keywords in dataset" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-non-alphanumeric.csv" }
      end

      it_behaves_like "an catalog with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-non-alphanumeric.csv" }
      end
    end

    context "an catalog file with a null download url" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-null-download-url.csv" }
      end

      it_behaves_like "an catalog with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-null-download-url.csv" }
      end
    end

    context "catalog with duplicated titles in datasets" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-with-duplicated-title.csv" }
      end
    end

    context "catalog with duplicated identifiers in datasets" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-with-duplicated-identifiers.csv" }
      end
    end

    context "blank file" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/invalid_file.txt" }
      end
    end

    context "file with ragged rows" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/ragged_rows_catalog.csv" }
      end
    end

    context "file with a blank row" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_catalog.csv" }
      end
    end

    context "file with a row with all fields in blank" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_catalog-2.csv" }
      end
    end

    context "csv file with no resources" do
      it_behaves_like "an invalid catalog file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/catalog-no-resources.csv" }
      end
    end
  end
end
