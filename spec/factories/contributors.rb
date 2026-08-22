FactoryBot.define do
  factory :contributor do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
