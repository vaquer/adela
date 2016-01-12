FactoryGirl.define do
  factory :xlsx_array_row, class: Array do
    xlsx_row do
      [
        Faker::Lorem.word, # ds:contact_position
        Faker::Lorem.sentence, # ds:title
        Faker::Lorem.sentence, # rs:title
        Faker::Lorem.paragraph, # rs:description
        'Público', # ds:access_level
        Faker::Lorem.sentence, # ds:access_comment'
        "application/#{Faker::App.name.downcase}", # rs:media_type
        Faker::Date.forward.iso8601 # ds:publish_date
      ]
    end

    initialize_with { xlsx_row }
  end
end
