class PackageVersion < ApplicationRecord
  belongs_to :cran_package
  belongs_to :package
  has_many :package_version_contributors, dependent: :destroy

  validates :version, presence: true
  validates :published_at, presence: true
end
