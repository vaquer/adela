FactoryGirl.define do
  factory :dataset do
    identifier { Faker::Lorem.words.join('-') }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    keyword { Faker::Lorem.words.join(',') }
    modified { Faker::Time.forward }
    contact_point { Faker::Name.name }
    mbox { Faker::Internet.email }
    temporal { "#{Faker::Date.backward.iso8601}/#{Faker::Date.forward.iso8601}" }
    spatial { Faker::Address.state }
    landing_page { Faker::Internet.url }
    accrual_periodicity 'R/P1Y'
    catalog

    trait :distributions do
      ignore do
        distributions_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |dataset, evaluator|
        create_list(:distribution, evaluator.distributions_count, dataset: dataset)
      end
    end
  end
end
