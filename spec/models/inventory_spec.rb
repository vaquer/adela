require 'spec_helper'

describe Inventory do
  context "validations" do
    before(:each) do
      @inventory = FactoryGirl.create(:inventory)
    end

    it "should be valid with mandatory fields" do
      @inventory.should be_valid
    end

    it "should not be valid without a file location" do
      @inventory.file_location = nil
      @inventory.should_not be_valid
    end

    it "should not be valid without an organization" do
      @inventory.organization_id = nil
      @inventory.should_not be_valid
    end
  end
end
