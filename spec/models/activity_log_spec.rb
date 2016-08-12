require 'spec_helper'

describe ActivityLog do
  shared_examples 'a valid activity log' do
    it 'should be valid' do
      expect(activity_log).to be_valid
    end
  end

  shared_examples 'an invalid activity log' do
    it 'should not be valid' do
      expect(activity_log).not_to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:activity_log) { create(:activity_log) }
    it_behaves_like 'a valid activity log'
  end

  context 'without an organization' do
    let(:activity_log) { build(:activity_log, organization: nil) }
    it_behaves_like 'an invalid activity log'
  end

  context 'without a message' do
    let(:activity_log) { build(:activity_log, message: nil) }
    it_behaves_like 'an invalid activity log'
  end
end
