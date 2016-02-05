require 'spec_helper'

describe OpeningPlanExporter do
  describe '#export' do
    subject(:exporter) do
      @organization = create(:organization, :officials, :catalog)
      OpeningPlanExporter.new(@organization)
    end

    before(:each) do
      @csv_rows = CSV.parse(subject.export).drop(1)
    end

    it 'should contain all datasets' do
      datasets_count = @organization.catalog.datasets.count
      expect(@csv_rows.length).to eq(datasets_count)
    end

    it 'should contain the liaison name' do
      @csv_rows.each do |row|
        liaison_name = @organization.liaison.user.name
        expect(liaison_name).to eq(row[1])
      end
    end

    it 'should contain the liaison email' do
      @csv_rows.each do |row|
        liaison_email = @organization.liaison.user.email
        expect(liaison_email).to eq(row[3])
      end
    end

    it 'should contain the administrator name' do
      @csv_rows.each do |row|
        administrator_name = @organization.administrator.user.name
        expect(administrator_name).to eq(row[4])
      end
    end

    it 'should contain the administrator email' do
      @csv_rows.each do |row|
        administrator_email = @organization.administrator.user.email
        expect(administrator_email).to eq(row[6])
      end
    end

    it 'should contain the datasets titles' do
      datasets_titles = @organization.catalog.datasets.map(&:title)
      @csv_rows.each do |row|
        include_row = datasets_titles.include?(row[7])
        expect(include_row).to be_truthy
      end
    end

    it 'should contain the datasets descriptions' do
      datasets_description = @organization.catalog.datasets.map(&:description)
      @csv_rows.each do |row|
        include_row = datasets_description.include?(row[8])
        expect(include_row).to be_truthy
      end
    end

    it 'should contain the datasets accrual periodicity values' do
      datasets_accrual_periodicity = @organization.catalog.datasets.map(&:accrual_periodicity)
      @csv_rows.each do |row|
        include_row = datasets_accrual_periodicity.include?(row[9])
        expect(include_row).to be_truthy
      end
    end

    it 'should contain the datasets publish dates' do
      datasets_publish_dates = @organization.catalog.datasets.map(&:publish_date)
      @csv_rows.each do |row|
        include_row = datasets_publish_dates.include?(row[10])
        expect(include_row).to be_truthy
      end
    end
  end
end
