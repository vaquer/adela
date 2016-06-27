FactoryGirl.define do
  factory :organization do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    landing_page { Faker::Internet.url }

    after(:build) do |organization|
      build(:inventory, organization: organization, authorization_file: nil, designation_file: nil)
    end

    trait :federal do
      gov_type { 'federal' }
    end

    trait :state do
      gov_type { 'state' }
    end

    trait :municipal do
      gov_type { 'municipal' }
    end

    trait :autonomous do
      gov_type { 'autonomous' }
    end

    trait :officials do
      after(:create) do |organization|
        create(:administrator, organization: organization)
        create(:liaison, organization: organization)
      end
    end

    trait :sector do
      after(:create) do |organization|
        create(:organization_sector, organization: organization)
      end
    end

    trait :catalog do
      after(:create) do |organization|
        create(:catalog, :datasets, organization: organization)
      end
    end
  end
end
