require 'spec_helper'

describe OpeningPlan do
  context 'validations' do
    subject { FactoryGirl.create :opening_plan_with_officials }

    it 'should be valid with mandatory fields' do
      expect(subject).to be_valid
    end

    it 'should not be valid without a dataset name' do
      subject.name = ''
      expect(subject).not_to be_valid
    end

    it 'should not be valid without a dataset description' do
      subject.name = ''
      expect(subject).not_to be_valid
    end

    it 'should not be valid without a publish date' do
      subject.publish_date = nil
      expect(subject).not_to be_valid
    end

    it 'should contain admin and liaison officials' do
      expect(subject.officials.map(&:kind).sort).to eq(%w(admin liaison))
    end
  end
end
