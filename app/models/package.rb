class Package < ApplicationRecord
  has_many :package_versions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
end
