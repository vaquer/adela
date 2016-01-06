FactoryGirl.define do
  factory :inventory do
    spreadsheet_file { File.new("#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx") }
    authorization_file { File.new("#{Rails.root}/spec/fixtures/files/authorization_file.jpg") }
    organization

    trait :elements do
      transient do
        datasets_count { Faker::Number.between(1, 5) }
        distributions_count { Faker::Number.between(1, 5) }
      end

      after(:create) do |inventory, evaluator|
        evaluator.datasets_count.times do
          create_list(:inventory_element, evaluator.distributions_count, inventory: inventory, dataset_title: Faker::Lorem.sentence)
        end
      end
    end
  end
end
