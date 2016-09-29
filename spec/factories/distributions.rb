FactoryGirl.define do
  factory :distribution do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    download_url { Faker::Internet.url }
    media_type { "application/#{Faker::App.name.downcase}" }
    byte_size { Faker::Number.number(8) }
    temporal { "#{Faker::Time.between(365.days.ago, Date.today, :all).strftime('%Y-%m-%d')}/#{Faker::Time.forward(365, :all).strftime('%Y-%m-%d')}"}
    modified { Faker::Time.forward }
    spatial { Faker::Address.state }
    issued {  Faker::Time.forward }
    publish_date { Time.current }
    format { Faker::App.name.downcase }

    factory :distribution_with_dataset do
      dataset
    end
  end
end
