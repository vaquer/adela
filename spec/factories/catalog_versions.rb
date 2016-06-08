FactoryGirl.define do
  factory :catalog_version do
    version foo: 'bar'
    catalog
  end
end
