#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name { Faker::Name.name }
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
    f.association :organization, :factory => :organization

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end

  factory :catalog do |f|
    f.csv_file File.new("#{Rails.root}/spec/fixtures/files/catalog.csv")
    f.association :organization, :factory => :organization
  end

  factory :published_catalog, :parent => :catalog do |f|
    f.published true
    f.publish_date DateTime.now
  end
end
