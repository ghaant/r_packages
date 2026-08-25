class PackageVersion < ApplicationRecord
  belongs_to :cran_package, class_name: "Cran::Package"
  belongs_to :package
  has_many :package_version_contributors, dependent: :destroy
  has_many :contributors, through: :package_version_contributors

  validates :version, presence: true
  validates :published_at, presence: true
  validates :version, uniqueness: { scope: :package_id, case_sensitive: false }
end
