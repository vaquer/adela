FactoryGirl.define do
  factory :dataset do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    keyword { Faker::Lorem.words.join(',') }
    modified { Faker::Time.forward }
    contact_position { Faker::Company.profession }
    contact_name { Faker::Name.name }
    mbox { Faker::Internet.email }
    temporal { "#{Faker::Date.backward.iso8601}/#{Faker::Date.forward.iso8601}" }
    spatial { "#{Faker::Address.latitude}/#{Faker::Address.longitude}" }
    landing_page { Faker::Internet.url }
    accrual_periodicity 'R/P1Y'
    issued { Faker::Time.forward }
    publish_date { Faker::Time.forward }
    comments { Faker::Lorem.paragraph }
    public_access true
    editable true
    catalog

    factory :catalog_dataset do
      contact_position nil
      mbox nil
      landing_page nil
      keyword ''

      transient do
        distributions_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |dataset, evaluator|
        create_list(:catalog_distribution, evaluator.distributions_count, dataset: dataset)
      end
    end

    trait :distributions do
      transient do
        distributions_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |dataset, evaluator|
        create_list(:distribution, evaluator.distributions_count, dataset: dataset)
      end
    end

    trait :sector do
      after(:create) do |dataset|
        create(:dataset_sector, dataset: dataset)
      end
    end
  end
end
