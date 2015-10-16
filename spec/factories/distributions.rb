FactoryGirl.define do
  factory :distribution do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    download_url { Faker::Internet.url }
    media_type { "application/#{Faker::App.name.downcase}" }
    byte_size { Faker::Number.number(8) }
    temporal { "#{Faker::Date.backward.iso8601}/#{Faker::Date.forward.iso8601}" }
    modified { Faker::Time.forward }
    spatial { Faker::Address.state }
    published true
    dataset

    trait :broke do
      download_url nil
      temporal nil
      modified nil
      state 'broke'
    end

    trait :validated do
      state 'validated'
    end

    trait :published do
      state 'published'
    end

    trait :unpublished do
      published false
    end
  end
end
