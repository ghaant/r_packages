FactoryBot.define do
  factory :package do
    name { Faker::App.name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
