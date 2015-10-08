FactoryGirl.define do
  factory :catalog do
    published true
    publish_date { Faker::Date.backward }
    author { Faker::Name.name }
    organization
  end
end
