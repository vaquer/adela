require 'spec_helper'

describe Distribution do
  shared_examples 'a valid distribution' do
    it 'should be valid ' do
      distribution.should be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:distribution) { create(:distribution) }
    it_behaves_like 'a valid distribution'
  end
end
