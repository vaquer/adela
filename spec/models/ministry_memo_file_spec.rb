require 'spec_helper'

RSpec.describe MinistryMemoFile, type: :model do
  shared_examples 'a valid ministry_memo_file' do
    it 'should be valid' do
      expect(ministry_memo_file).to be_valid
    end
  end

  shared_examples 'an invalid ministry_memo_file' do
    it 'should be invalid' do
      expect(ministry_memo_file).not_to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:ministry_memo_file) { build_stubbed(:ministry_memo_file) }
    it_behaves_like 'a valid ministry_memo_file'
  end

  context 'without an organization' do
    let(:ministry_memo_file) { build_stubbed(:ministry_memo_file, organization: nil) }
    it_behaves_like 'an invalid ministry_memo_file'
  end

  context 'without a memo file' do
    let(:ministry_memo_file) { build_stubbed(:ministry_memo_file, file: nil) }
    it_behaves_like 'an invalid ministry_memo_file'
  end
end
