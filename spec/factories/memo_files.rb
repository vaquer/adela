FactoryGirl.define do
  factory :memo_file do
    file { File.new("#{Rails.root}/spec/fixtures/files/memo_file.pdf") }
    organization
  end
end
