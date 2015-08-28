require 'spec_helper'

describe InventoryRow do
  context 'with all public mandatory fields' do
    let(:inventory_row) { build(:inventory_row) }

    it 'should be valid' do
      inventory_row.should be_valid
    end
  end

  context 'with all private mandatory fields' do
    let(:inventory_row) { build(:inventory_row, :private) }

    it 'should be valid' do
      inventory_row.should be_valid
    end
  end

  context 'without a responsible official' do
    let(:inventory_row) { build(:inventory_row, responsible: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a dataset title' do
    let(:inventory_row) { build(:inventory_row, dataset_title: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a resource title' do
    let(:inventory_row) { build(:inventory_row, resource_title: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a dataset description' do
    let(:inventory_row) { build(:inventory_row, dataset_description: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without an accessor' do
    let(:inventory_row) { build(:inventory_row, private_data: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a media type' do
    let(:inventory_row) { build(:inventory_row, media_type: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a publish date' do
    let(:inventory_row) { build(:inventory_row, publish_date: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without an ISO8601 publish date' do
    let(:inventory_row) { build(:inventory_row, publish_date: '17-02-1989') }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a month and a year in publish date' do
    let(:inventory_row) { build(:inventory_row, publish_date: '1989') }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a data access comment with private data' do
    let(:inventory_row) { build(:inventory_row, :private, data_access_comment: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end

  context 'without a publish date comment with public data' do
    let(:inventory_row) { build(:inventory_row, :public, publish_date: nil) }

    it 'should not be valid' do
      inventory_row.should_not be_valid
    end
  end
end
