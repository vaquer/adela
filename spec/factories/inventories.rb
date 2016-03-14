FactoryGirl.define do
  factory :inventory do
    spreadsheet_file { File.new("#{Rails.root}/spec/fixtures/files/inventario_general_de_datos.xlsx") }
    authorization_file { File.new("#{Rails.root}/spec/fixtures/files/authorization_file.jpg") }
    designation_file { File.new("#{Rails.root}/spec/fixtures/files/oficio_designacion.docx") }
    organization
  end
end
