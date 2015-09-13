require 'spec_helper'

describe OpeningPlanExporter do
  describe '#export' do
    subject do
      opening_plan = create(:opening_plan_with_officials)
      OpeningPlanExporter.new(opening_plan.organization)
    end

    it 'should contain opening plan vision column' do
      csv_content = CSV.parse(subject.export)
      vision = opening_plan(subject).vision
      expect(csv_content.join).to match(vision)
    end

    it 'should contain opening plan name column' do
      csv_content = CSV.parse(subject.export)
      name = opening_plan(subject).name
      expect(csv_content.join).to match(name)
    end

    it 'should contain opening plan description column' do
      csv_content = CSV.parse(subject.export)
      description = opening_plan(subject).description
      expect(csv_content.join).to match(description)
    end

    it 'should contain opening plan publish_date column' do
      csv_content = CSV.parse(subject.export)
      publish_date = opening_plan(subject).publish_date.strftime('%Y-%m-%d')
      expect(csv_content.join).to match(publish_date)
    end

    it 'should contain opening plan accrual_periodicity column' do
      csv_content = CSV.parse(subject.export)
      accrual_periodicity = opening_plan(subject).accrual_periodicity
      expect(csv_content.join).to match(accrual_periodicity)
    end

    it 'should contain opening plan liaison official name column' do
      csv_content = CSV.parse(subject.export)
      name = liaison_official(subject).name
      expect(csv_content.join).to match(name)
    end

    it 'should contain opening plan liaison official position column' do
      csv_content = CSV.parse(subject.export)
      position = liaison_official(subject).position
      expect(csv_content.join).to match(position)
    end

    it 'should contain opening plan liaison official email column' do
      csv_content = CSV.parse(subject.export)
      email = liaison_official(subject).email
      expect(csv_content.join).to match(email)
    end

    it 'should contain opening plan admin official name column' do
      csv_content = CSV.parse(subject.export)
      name = admin_official(subject).name
      expect(csv_content.join).to match(name)
    end

    it 'should contain opening plan admin official position column' do
      csv_content = CSV.parse(subject.export)
      position = admin_official(subject).position
      expect(csv_content.join).to match(position)
    end

    it 'should contain opening plan admin official email column' do
      csv_content = CSV.parse(subject.export)
      email = admin_official(subject).email
      expect(csv_content.join).to match(email)
    end

    def opening_plan(subject)
      subject.organization.opening_plans.first
    end

    def liaison_official(subject)
      opening_plan(subject).officials.find(&:liaison?)
    end

    def admin_official(subject)
      opening_plan(subject).officials.find(&:admin?)
    end
  end
end
