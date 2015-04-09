#encoding: utf-8
FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "user#{n}@example.com" }
    f.name 'Rodrigo'
    f.password 'secretpassword'
    f.password_confirmation 'secretpassword'
    f.association :organization, :factory => :organization

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    factory :supervisor do
      after(:create) { |user| user.add_role(:supervisor) }
    end
  end

  factory :organization do |f|
    f.title "Hacienda"
  end

  factory :inventory do |f|
    f.csv_file File.new("#{Rails.root}/spec/fixtures/files/inventory.csv")
    f.association :organization, :factory => :organization
  end

  factory :published_inventory, :parent => :inventory do |f|
    f.published true
    f.publish_date DateTime.now
  end

  factory :topic do |f|
    f.name "Un tema de apertura"
    f.owner "Don Fulanito de Tal"
    f.description "Información adicional"
    f.sequence(:sort_order)
    f.published false
    f.publish_date DateTime.now
    f.association :organization, :factory => :organization
  end

  factory :published_topic, :parent => :topic do |f|
    f.published true
    f.publish_date DateTime.now
  end
end
