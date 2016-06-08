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

  context '#openess_rating' do
    let(:dataset) { create(:dataset) }

    it 'should have an score of 1' do
      create(:distribution, dataset: dataset)
      expect(dataset.openess_rating).to eq(1)
    end

    it 'should have an score of 2 with a xls distribution' do
      create(:distribution, dataset: dataset, format: 'xls')
      expect(dataset.openess_rating).to eq(2)
    end

    it 'should have an score of 2 with a xlsx distribution' do
      create(:distribution, dataset: dataset, format: 'xlsx')
      expect(dataset.openess_rating).to eq(2)
    end

    it 'should have an score of 2 with a csv distribution' do
      create(:distribution, dataset: dataset, format: 'csv')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a json distribution' do
      create(:distribution, dataset: dataset, format: 'json')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a shp distribution' do
      create(:distribution, dataset: dataset, format: 'shp')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a psv distribution' do
      create(:distribution, dataset: dataset, format: 'psv')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a tsv distribution' do
      create(:distribution, dataset: dataset, format: 'tsv')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a kml distribution' do
      create(:distribution, dataset: dataset, format: 'kml')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a kmz distribution' do
      create(:distribution, dataset: dataset, format: 'kmz')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 2 with a xml distribution' do
      create(:distribution, dataset: dataset, format: 'xml')
      expect(dataset.openess_rating).to eq(3)
    end

    it 'should have an score of 5 with a rdf distribution' do
      create(:distribution, dataset: dataset, format: 'rdf')
      expect(dataset.openess_rating).to eq(4)
    end

    it 'should have an score of 5 with a lod distribution' do
      create(:distribution, dataset: dataset, format: 'lod')
      expect(dataset.openess_rating).to eq(5)
    end
  end
end
