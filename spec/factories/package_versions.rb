FactoryBot.define do
  factory :package_version do
    association :package
    version { Faker::App.version }
    published_at { Faker::Date.backward(days: 365) }
  end
end
