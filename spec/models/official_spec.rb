require 'spec_helper'

describe Official do
  context 'validations' do
    subject { FactoryGirl.create :official }

    it 'should be valid with mandatory fields' do
      subject.should be_valid
    end
  end
end
