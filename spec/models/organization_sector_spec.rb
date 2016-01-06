require 'spec_helper'

describe OrganizationSector do
  context 'with all mandatory fields' do
    let(:organization_sector) { create(:organization_sector) }
    it 'should be valid with all mandatory fields' do
      expect(organization_sector).to be_valid
    end
  end
end
