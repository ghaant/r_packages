class Contributor < ApplicationRecord
  has_many :package_version_contributors, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
