FactoryGirl.define do
  factory :inventory_row do
    sequence(:number)
    responsible Faker::Company.name
    dataset_title Faker::Lorem.sentence
    resource_title Faker::Lorem.sentence
    dataset_description Faker::Lorem.sentence
    media_type Faker::App.name

    public
    skip_create

    trait :private do
      private_data true
      data_access_comment Faker::Lorem.sentence
    end

    trait :public do
      private_data false
      publish_date { Faker::Date.forward.iso8601 }
    end
  end
end
