require 'spec_helper'

describe OpeningPlan do
  context "validations" do
    subject { FactoryGirl.create :opening_plan_with_officials }

    it "should be valid with mandatory fields" do
      subject.should be_valid
    end

    it "should not be valid without a dataset name" do
      subject.name = ""
      subject.should_not be_valid
    end

    it "should not be valid without a dataset description" do
      subject.name = ""
      subject.should_not be_valid
    end

    it "should not be valid without a publish date" do
      subject.publish_date = nil
      subject.should_not be_valid
    end

    it "should contain admin and liaison officials" do
      subject.officials.map(&:kind).sort.should == ["admin", "liaison"]
    end
  end
end
