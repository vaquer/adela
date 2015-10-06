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
  end
end
