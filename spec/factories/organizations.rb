FactoryGirl.define do
  factory :organization do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    logo_url { Faker::Company.logo }

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

    trait :sector do
      after(:create) do |organization|
        create(:organization_sector, organization: organization)
      end
    end

    trait :opening_plan do
      ignore do
        opening_plan_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |organization, evaluator|
        create_list(:opening_plan, evaluator.opening_plan_count, organization: organization)
      end
    end
  end
end
