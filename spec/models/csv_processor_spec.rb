require 'spec_helper'

describe CsvProcessor do
  describe "#process" do
    subject do
      CsvProcessor.new(FactoryGirl.create(:catalog).csv_file, FactoryGirl.create(:organization))
    end

    it "gets the datasets from the file" do
      subject.process.size.should == 2
      subject.process[0].distributions.size.should == 3
      subject.process[1].distributions.size.should == 4
    end
  end
end