require 'spec_helper'

describe CatalogsController do
  describe 'PUTS #publish' do
    before { ActionMailer::Base.deliveries = [] }

    before(:each) do
      @user = create(:user, :administrator)
      @organization = @user.organization
      create(:catalog, :datasets, organization: @organization)
      sign_in(@user)
      distribution_ids = @organization.catalog.distributions.map(&:id)

      put :publish, id: @organization.id, catalog: { distribution_ids: distribution_ids }, locale: :es
    end

    it 'sends an email to administrator' do
      deliveries_count = ActionMailer::Base.deliveries.count
      expect(deliveries_count).to eq(1)
    end

    it 'enqueues the harvest job' do
      catalog_url = "http://adela.datos.gob.mx/#{@organization.slug}/catalogo.json"
      expect(ShogunHarvestWorker.jobs.size).to eq(1)
    end
  end
end
