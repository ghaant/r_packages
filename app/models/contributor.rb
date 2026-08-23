class Contributor < ApplicationRecord
  has_many :package_version_contributors, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
