require 'spec_helper'

describe CatalogsController do
  describe 'PUTS #publish' do
    let(:user) { create(:organization_administrator) }
    let(:catalog) { create(:catalog_with_datasets, organization: user.organization) }

    before { ActionMailer::Base.deliveries = [] }

    before(:each) do
      sign_in(user)
      distribution_ids = catalog.distributions.map(&:id)
      put :publish, id: user.organization.id, catalog: { distribution_ids: distribution_ids }, locale: :es
    end

    it 'sends an email to administrator' do
      deliveries_count = ActionMailer::Base.deliveries.count
      expect(deliveries_count).to eq(1)
    end

    it 'enqueues the harvest job' do
      expect(ShogunHarvestWorker.jobs.size).to eq(1)
    end
  end
end
