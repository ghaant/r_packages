class PackageVersion < ApplicationRecord
  belongs_to :package
  has_many :package_version_contributors, dependent: :destroy

  validates :version, presence: true
  validates :publication_date, presence: true
end
