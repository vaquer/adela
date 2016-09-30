FactoryGirl.define do
  factory :distribution do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    download_url { Faker::Internet.url }
    media_type { "application/#{Faker::App.name.downcase}" }
    byte_size { Faker::Number.number(8) }
    modified { Faker::Time.backward(365) }
    temporal { "#{Faker::Time.between(365.days.ago, Date.today, :all).strftime('%Y-%m-%d')}/#{Faker::Time.forward(365, :all).strftime('%Y-%m-%d')}"}
    spatial { Faker::Address.state }
    issued {  Faker::Time.forward }
    publish_date { Time.current }
    tools { Faker::Lorem.paragraph }
    codelist { Faker::Lorem.paragraph }
    codelist_link { Faker::Internet.url }
    copyright { Faker::Lorem.sentence }
    format { Faker::App.name.downcase }

    factory :distribution_with_dataset do
      dataset
    end
  end
end
