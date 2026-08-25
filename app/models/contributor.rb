class Contributor < ApplicationRecord
  has_many :package_version_contributors, dependent: :destroy
  has_many :package_versions, through: :package_version_contributors

  validates :name, presence: true, uniqueness: true
end
