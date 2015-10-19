#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name { Faker::Name.name }
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
    f.association :organization, :factory => :organization

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :administrator do
      after(:create) do |user|
        create(:administrator, user: user, organization: user.organization)
      end
    end
  end

  factory :published_catalog, :parent => :catalog do |f|
    f.published true
    f.publish_date DateTime.now
  end
end
