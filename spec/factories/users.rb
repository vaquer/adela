FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    name { Faker::Name.name }
    password 'secretpassword'
    password_confirmation 'secretpassword'
    organization

    factory :organization_administrator do
      after(:create) { |user| create(:administrator, user: user, organization: user.organization) }
    end

    factory :super_user do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
