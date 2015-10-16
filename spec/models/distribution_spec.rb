require 'spec_helper'

describe Distribution do
  shared_examples 'a valid distribution' do
    it 'should be valid' do
      expect(distribution).to be_valid
    end
  end

  shared_examples 'a compliant distribution' do
    it 'should be compliant' do
      expect(distribution.compliant?).to be_true
    end
  end

  shared_examples 'a non compliant distribution' do
    it 'should be non compliant' do
      expect(distribution.compliant?).to be_false
    end
  end

  context 'with all mandatory fields' do
    let(:distribution) { create(:distribution) }
    it_behaves_like 'a valid distribution'
  end

  context 'with all fields' do
    let(:distribution) { create(:distribution) }
    it_behaves_like 'a compliant distribution'
  end

  context 'with a nil download_url' do
    let(:distribution) { create(:distribution, download_url: nil) }
    it_behaves_like 'a non compliant distribution'
  end

  context 'with a nil temporal' do
    let(:distribution) { create(:distribution, temporal: nil) }
    it_behaves_like 'a non compliant distribution'
  end

  context 'with a nil modified' do
    let(:distribution) { create(:distribution, modified: nil) }
    it_behaves_like 'a non compliant distribution'
  end
end
