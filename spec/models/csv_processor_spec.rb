require 'spec_helper'

describe CsvProcessor do
  describe "#process" do
    subject do
      CsvProcessor.new(FactoryGirl.create(:inventory).csv_file, FactoryGirl.create(:organization))
    end

    it "gets the datasets from the file" do
      subject.process.size.should == 2
      subject.process[0].distributions.size.should == 3
      subject.process[1].distributions.size.should == 4
    end
  end

  describe "#generate_csv" do
    subject do
      @temporary_path = "#{Rails.root}/tmp/inventory.csv"
      @organization = FactoryGirl.create(:organization)
      CsvProcessor.new(File.open("#{Rails.root}/spec/fixtures/files/partial_invalid_inventory.csv"), @organization)
    end

    it "creates new file only with valid datasets and distributions" do
      subject.generate_csv(@temporary_path)
      inventory = FactoryGirl.build(:inventory, :csv_file => File.open(@temporary_path), :organization => @organization)
      inventory.should be_valid
      inventory.datasets.size.should == 2
      inventory.datasets[1].distributions.size.should == 0 
    end
  end
end