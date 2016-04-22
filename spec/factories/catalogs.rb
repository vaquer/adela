FactoryGirl.define do
  factory :catalog do
    published true
    publish_date { Faker::Date.backward }
    author { Faker::Name.name }
    organization

    trait :unpublished do
      published false
      publish_date nil
    end

    trait :datasets do
      transient do
        datasets_count { Faker::Number.between(1, 8) }
      end

      after(:create) do |catalog, evaluator|
        create_list(:catalog_dataset, evaluator.datasets_count, catalog: catalog)
      end
    end

    factory :catalog_with_documented_datasets do
      transient do
        datasets_count { Faker::Number.between(1, 8) }
      end

      after(:create) do |catalog, evaluator|
        create_list(:dataset, evaluator.datasets_count, catalog: catalog)
      end
    end
  end
end
