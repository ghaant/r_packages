class PackageVersionContributor < ApplicationRecord
  belongs_to :package_version
  belongs_to :contributor

  validates :is_author, inclusion: { in: [true, false] }
  validates :is_maintainer, inclusion: { in: [true, false] }
  validates :is_author, inclusion: { in: [true] }, unless: -> { is_maintainer }
  validates :is_maintainer, inclusion: { in: [true] }, unless: -> { is_author }
end
