FactoryGirl.define do
  factory :designation_file do
    file { File.new("#{Rails.root}/spec/fixtures/files/designation_file.docx") }
    organization
  end
end
