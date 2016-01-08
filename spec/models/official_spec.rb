require 'spec_helper'

describe Official do
  context 'validations' do
    subject { FactoryGirl.create :official }

    it 'should be valid with mandatory fields' do
      expect(subject).to be_valid
    end
  end
end
