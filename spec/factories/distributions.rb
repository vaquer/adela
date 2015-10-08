FactoryGirl.define do
  factory :distribution do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    download_url { Faker::Internet.url }
    media_type { "application/#{Faker::App.name.downcase}" }
    byte_size { Faker::Number.number(8) }
    temporal { "#{Faker::Date.backward.iso8601}/#{Faker::Date.forward.iso8601}" }
    spatial { Faker::Address.state }
    dataset
  end
end
