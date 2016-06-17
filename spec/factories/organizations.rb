FactoryGirl.define do
  factory :organization do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    landing_page { Faker::Internet.url }

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

    trait :catalog do
      after(:create) do |organization|
        create(:catalog, organization: organization)
      end
    end

    trait :opening_plan do
      transient do
        datasets_count { Faker::Number.between(1, 5) }
        distributions_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |organization, evaluator|
        create_list(:opening_plan, evaluator.datasets_count, organization: organization)

        # creates inventory and inventory elements
        inventory = create(:inventory, organization: organization)
        organization.opening_plans.each do |opening_plan|
          evaluator.distributions_count.times do
            create(:inventory_element, inventory: inventory, dataset_title: opening_plan.name)
          end
        end
      end
    end
  end
end
