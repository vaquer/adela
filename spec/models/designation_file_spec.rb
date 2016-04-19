require 'spec_helper'

RSpec.describe DesignationFile, type: :model do
  shared_examples 'a valid designation_file' do
    it 'should be valid' do
      expect(designation_file).to be_valid
    end
  end

  shared_examples 'an invalid designation_file' do
    it 'should be invalid' do
      expect(designation_file).not_to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:designation_file) { build_stubbed(:designation_file) }
    it_behaves_like 'a valid designation_file'
  end

  context 'without an organization' do
    let(:designation_file) { build_stubbed(:designation_file, organization: nil) }
    it_behaves_like 'an invalid designation_file'
  end

  context 'without a designation file' do
    let(:designation_file) { build_stubbed(:designation_file, file: nil) }
    it_behaves_like 'an invalid designation_file'
  end
end
