require 'spec_helper'

describe OpeningPlan do
  context "validations" do
    subject { FactoryGirl.create :opening_plan_with_officials }

    it "should be valid with mandatory fields" do
      subject.should be_valid
    end

    it "should not be valid without an institutional vision" do
      subject.vision = ""
      subject.should_not be_valid
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

    it "should not be valid without officials" do
      subject.officials = []
      subject.should_not be_valid
    end

    it "should contain admin and liaison officials" do
      subject.officials.map(&:kind).sort.should == ["admin", "liaison"]
    end
  end

  describe "::by_month" do
    before :each do
      @next_month = Date.today + 1.month
      @next_year  = Date.today + 1.year

      FactoryGirl.create(:opening_plan_with_officials, publish_date: @next_month)
      FactoryGirl.create(:opening_plan_with_officials, publish_date: @next_year)

      @opening_plans = 3.times.map do
        FactoryGirl.create(:opening_plan_with_officials)
      end
      @opening_plans.sort!
    end

    it "should return current month opening plan" do
      OpeningPlan.by_month.sort.should == @opening_plans
    end
  end
end
