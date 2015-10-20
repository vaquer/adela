require 'spec_helper'

describe ShogunHarvestWorker do
  let(:catalog_url) { Faker::Internet.url }

  before(:each) do
    ShogunHarvestWorker.perform_async(catalog_url)
  end

  it 'enqueues the harvest job' do
    expect(ShogunHarvestWorker).to have_enqueued_job(catalog_url)
  end
end
