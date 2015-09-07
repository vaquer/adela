FactoryGirl.define do
  factory :official do
    name { Faker::Name.name }
    position { Faker::Commerce.department }
    email { Faker::Internet.email }
    liaison

    trait :liaison do
      kind :liaison
    end

    trait :admin do
      kind :admin
    end
  end
end
