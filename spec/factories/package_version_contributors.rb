FactoryBot.define do
  factory :package_version_contributor do
    association :package_version
    association :contributor
    is_author { false }
    is_maintainer { true }
  end
end
