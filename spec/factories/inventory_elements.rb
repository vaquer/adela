FactoryGirl.define do
  factory :inventory_element do
    sequence(:row)
    responsible { Faker::Company.name }
    dataset_title { Faker::Lorem.sentence }
    resource_title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    media_type { Faker::App.name }
    inventory
    public # default trait

    trait :public do
      private false
      publish_date { Faker::Date.forward.iso8601 }
    end

    trait :private do
      private true
      access_comment { Faker::Lorem.sentence }
    end
  end
end
