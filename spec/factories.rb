#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name 'Rodrigo'
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
    f.association :organization, :factory => :organization
  end

  factory :organization do |f|
    f.title "Hacienda"
  end

  factory :inventory do |f|
    f.csv_file File.new("#{Rails.root}/spec/fixtures/files/inventory.csv")
    f.association :organization, :factory => :organization
  end
end