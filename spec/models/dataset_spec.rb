require 'spec_helper'

describe Dataset do
  shared_examples 'a valid dataset' do
    it 'should be valid ' do
      expect(dataset).to be_valid
    end
  end

  context 'with all mandatory fields' do
    let(:dataset) { create(:dataset) }
    it_behaves_like 'a valid dataset'
  end

  context '.build_from_xlsx_row' do
    let(:catalog) { create(:catalog) }
    let(:xlsx_row) { build(:xlsx_array_row) }

    it 'should respond to build_from_xlsx_row method' do
      expect(Dataset).to respond_to(:build_from_xlsx_row)
    end

    it 'should create a dataset' do
      dataset = Dataset.build_from_xlsx_row(catalog, xlsx_row)
      expect(dataset.persisted?).to be_truthy
    end

    it 'should create a dataset with a distribution' do
      dataset = Dataset.build_from_xlsx_row(catalog, xlsx_row)
      expect(dataset.distributions.count).to eq(1)
    end

    it 'should update an existing dataset' do
      dataset = create(:dataset, catalog: catalog, title: xlsx_row[1], contact_position: nil)

      Dataset.build_from_xlsx_row(catalog, xlsx_row)
      dataset.reload

      expect(dataset.contact_position).to_not be_nil
    end

    it 'should update the distributions' do
      dataset = create(:dataset, catalog: catalog, title: xlsx_row[1])
      distribution = create(:distribution, dataset: dataset, title: xlsx_row[2], description: '')

      Dataset.build_from_xlsx_row(catalog, xlsx_row)
      distribution.reload

      expect(distribution.description).to_not be_nil
    end
  end

  context '#identifier' do
    let(:dataset) { create(:dataset, title: 'Módulos de internet gratuitos en Xalapa') }

    it 'should generate a slugged identifier from title' do
      expect(dataset.identifier).to eql('modulos-de-internet-gratuitos-en-xalapa')
    end
  end

  context '#publisher' do
    it 'should be equal to the organization title' do
      dataset = create(:dataset)
      organization = dataset.catalog.organization.title
      expect(dataset.publisher).to eql(organization)
    end
  end

  context '#keywords' do
    it 'should include the dataset keyword' do
      dataset = create(:dataset)
      expect(dataset.keywords).to include(dataset.keyword)
    end

    it 'should include the organization sectors' do
      organization = create(:organization, :sector)
      dataset = create(:dataset)
      dataset.catalog.organization = organization

      expect(dataset.keywords).to include(organization.sectors.first.slug)
    end
  end

  context '#sectors' do
    it 'should include the organization sectors slug' do
      organization = create(:organization, :sector)
      dataset = create(:dataset)
      dataset.catalog.organization = organization

      sectors = dataset.send(:sectors)
      expect(sectors).to include(organization.sectors.first.slug)
    end
  end
end
