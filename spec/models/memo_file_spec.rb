require 'spec_helper'

RSpec.describe MemoFile, type: :model do
  shared_examples 'a valid memo_file' do
    it 'should be valid' do
      expect(memo_file).to be_valid
    end
  end

  shared_examples 'an invalid memo_file' do
    it 'should be invalid' do
      expect(memo_file).not_to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:memo_file) { build_stubbed(:memo_file) }
    it_behaves_like 'a valid memo_file'
  end

  context 'without an organization' do
    let(:memo_file) { build_stubbed(:memo_file, organization: nil) }
    it_behaves_like 'an invalid memo_file'
  end

  context 'without a memo file' do
    let(:memo_file) { build_stubbed(:memo_file, file: nil) }
    it_behaves_like 'an invalid memo_file'
  end
end
