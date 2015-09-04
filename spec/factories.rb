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

  factory :opening_plan do |f|
    f.vision "Visión institucional de datos abiertos"
    f.name "Conjuntos de datos priorizados"
    f.description "Descripción de los conjuntos"
    f.publish_date Date.today
    f.accrualPeriodicity "R/P1Y"
    f.association :organization, :factory => :organization

    factory :opening_plan_with_officials do
      after(:build) do |opening_plan|
        opening_plan.officials << FactoryGirl.build(:official, opening_plan: opening_plan, kind: :liaison)
        opening_plan.officials << FactoryGirl.build(:official, opening_plan: opening_plan, kind: :admin)
      end
    end
  end

  factory :official do |f|
    f.name "Elton Spencer"
    f.position "Commissioner for Digital Agenda"
    f.email "elton@spencer.com"
    f.kind :liaison
  end
end
