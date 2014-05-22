require 'spec_helper'

describe Topic do
  context "validations" do
    subject { FactoryGirl.create :topic }

    it "should be valid with mandatory fields" do
      subject.should be_valid
    end

    it "should not be valid without a name" do
      subject.name = ""
      subject.should_not be_valid
    end

    it "should not be valid without an owner" do
      subject.owner = ""
      subject.should_not be_valid
    end

    it "should not be valid without an organization" do
      subject.organization = nil
      subject.should_not be_valid
    end

    it "should not be valid without a sort order" do
      subject.sort_order = nil
      subject.should_not be_valid
    end
  end
end
