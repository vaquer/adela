FactoryGirl.define do
  factory :ministry_memo_file do
    file { File.new("#{Rails.root}/spec/fixtures/files/ministry_memo_file.pdf") }
    organization
  end
end
