require 'spec_helper'

describe InventoryElement do
  shared_examples 'a valid inventory element' do
    it 'should be compliant' do
      expect(inventory_element.compliant?).to be true
    end

    it 'should be valid' do
      expect(inventory_element).to be_valid
    end
  end

  shared_examples 'an invalid inventory element' do
    it 'should not be valid' do
      expect(inventory_element).not_to be_valid
    end
  end

  shared_examples 'a non compliant inventory element' do
    it 'should not be compliant' do
      expect(inventory_element.compliant?).not_to be true
    end
  end

  context 'with all public mandatory fields' do
    let(:inventory_element) { build(:inventory_element) }
    it_behaves_like 'a valid inventory element'
  end

  context 'with all private mandatory fields' do
    let(:inventory_element) { build(:inventory_element, :private) }
    it_behaves_like 'a valid inventory element'
  end

  context 'without an inventory' do
    let(:inventory_element) { build(:inventory_element, inventory: nil) }
    it_behaves_like 'an invalid inventory element'
  end

  context 'without a responsible' do
    let(:inventory_element) { build(:inventory_element, responsible: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without a dataset title' do
    let(:inventory_element) { build(:inventory_element, dataset_title: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without a resource title' do
    let(:inventory_element) { build(:inventory_element, resource_title: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without a description' do
    let(:inventory_element) { build(:inventory_element, description: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without a private flag' do
    let(:inventory_element) { build(:inventory_element, private: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without a media type' do
    let(:inventory_element) { build(:inventory_element, media_type: nil) }
    it_behaves_like 'a non compliant inventory element'
  end

  context 'without an access comment with private data' do
    let(:inventory_element) { build(:inventory_element, :private, access_comment: nil) }
    it_behaves_like 'a non compliant inventory element'
  end
end
