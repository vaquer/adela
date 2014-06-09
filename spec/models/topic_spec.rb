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
  end

  describe "#sort_order" do
    subject do
      Topic.new :name => "Topic",
        :owner => "Owner",
        :organization => FactoryGirl.create(:organization)
    end

    it "automatically sets a sort_order when creating" do
      subject.save!
      subject.sort_order.should == 1
    end

    it "sets the sorts_order to be one more than previous one" do
      FactoryGirl.create :topic, :sort_order => 1, :organization_id => subject.organization_id
      FactoryGirl.create :topic, :sort_order => 2, :organization_id => subject.organization_id
      FactoryGirl.create :topic, :sort_order => 3, :organization_id => subject.organization_id

      subject.save!
      subject.sort_order.should == 4
    end
  end
end
