require 'spec_helper'

describe User do
  context 'validations' do
    let(:user) { create(:user) }

    it 'should be valid with mandatory attributes' do
      expect(user).to be_valid
    end

    it 'should not be valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'should not be valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'should not be valid with a short password' do
      user.password = 'short'
      user.password_confirmation = 'short'
      expect(user).not_to be_valid
    end
  end

  context 'scopes' do
    describe '::organization' do
      let(:organization) { create(:organization) }

      it 'should return all the users that belongs to an organization' do
        create(:user) # an user that belongs to another organization
        organization_total_users = rand(1..10).times do
          create(:user, organization: organization)
        end

        users = User.organization(organization.id)
        expect(users.count).to eql(organization_total_users)
      end
    end

    describe '::email' do
      let(:user) { create(:user) }

      it 'should return all the users with that match a given email' do
        rand(1..10).times { create(:user) }

        users = User.email(user.email)
        expect(users.count).to eql(1)
      end
    end

    describe '::names' do
      let!(:user) { create(:user, name: 'Benito Juárez García') }
      it 'should return all the users that match a given name' do
        rand(1..10).times { create(:user) }

        users = User.names('Benito')
        expect(users.count).to eql(1)
      end
    end
  end
end
