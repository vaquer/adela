FactoryGirl.define do
  factory :user do |f|
    sequence :email do |n|
      "user#{n}@example.com"
    end
    name { Faker::Name.name }
    password 'secretpassword'
    password_confirmation 'secretpassword'
    organization

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :administrator do
      after(:create) do |user|
        create(:administrator, user: user, organization: user.organization)
      end
    end
  end
end
