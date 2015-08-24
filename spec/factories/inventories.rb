FactoryGirl.define do
  factory :inventory do
    spreadsheet_file { File.new("#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx") }
    organization
  end
end
