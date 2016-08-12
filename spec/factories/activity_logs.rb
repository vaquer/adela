FactoryGirl.define do
  factory :activity_log do
    message { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    organization
  end
end
