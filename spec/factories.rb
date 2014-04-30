#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name 'Rodrigo'
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
  end
end