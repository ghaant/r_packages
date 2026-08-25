class PackageVersionContributor < ApplicationRecord
  belongs_to :package_version
  belongs_to :contributor

  validates :is_author, inclusion: { in: [true] }, unless: -> { is_maintainer }
  validates :is_maintainer, inclusion: { in: [true] }, unless: -> { is_author }
  validates :package_version_id, uniqueness: { scope: :contributor_id }
  validates :contributor_id, uniqueness: { scope: :package_version_id }
end
