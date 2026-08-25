class Cran::Package < ApplicationRecord
  has_one :package_version, foreign_key: :cran_package_id, dependent: :destroy

  after_create { Cran::PackageProcessorJob.perform_later(id) }
end
