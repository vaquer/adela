require 'spec_helper'

describe CsvProcessor do
  describe "#process" do
    context "an organization catalog" do
      subject do
        CsvProcessor.new(FactoryGirl.create(:catalog).csv_file, FactoryGirl.create(:organization))
      end

      it "gets the datasets from the file" do
        subject.process.size.should == 2
        subject.process[0].distributions.size.should == 3
        subject.process[1].distributions.size.should == 4
      end
    end

    context "an organization with sectors catalog" do
      subject do
        organization = create(:organization, :sector)
        csv_file = create(:catalog).csv_file
        CsvProcessor.new(csv_file, organization)
      end

      it "contains the organization sectors in the keywords" do
        sector_keyword = subject.organization.sectors.first.title
        includes_sector = subject.process[0].keywords.include?(sector_keyword)
        expect(includes_sector).to be true
      end
    end
  end
end
