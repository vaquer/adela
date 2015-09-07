FactoryGirl.define do
  factory :opening_plan do
    vision { Faker::Lorem.sentence }
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    publish_date { Faker::Date.forward }
    accrual_periodicity 'R/P1Y'
    organization

    factory :opening_plan_with_officials do
      after(:build) do |opening_plan|
        opening_plan.officials << build(:official, :liaison, opening_plan: opening_plan)
        opening_plan.officials << build(:official, :admin, opening_plan: opening_plan)
      end
    end
  end
end
