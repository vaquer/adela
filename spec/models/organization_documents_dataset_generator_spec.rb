require 'spec_helper'

describe OrganizationDocumentsDatasetGenerator do
  let!(:organization) { create(:organization) }
  let!(:administrator) { create(:administrator, organization: organization) }
  let!(:inventory) { create(:inventory, organization: organization) }
  let!(:catalog) { create(:catalog_with_datasets, organization: organization) }
  let!(:sector) { create(:sector, title: 'Otros') }
  let!(:generator) { OrganizationDocumentsDatasetGenerator.new(organization) }

  describe '#generate!' do
    it 'should create the organization documents dataset' do
      generator.generate!
      datasets = Dataset.where("title LIKE 'Oficios y Documentos Institucionales de #{organization.title}'")
      expect(datasets.size).to eq(1)
    end

    it 'should create single distribution for the opening plan dataset' do
      generator.generate!
      distributions = Distribution.where("title LIKE 'Oficios y Documentos Institucionales de #{organization.title}'")
      expect(distributions.size).to eq(1)
    end
  end
end
