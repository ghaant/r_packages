class Cran::Package < ApplicationRecord
  has_one :package_version

  after_create { Cran::PackageProcessorJob.perform_later(id) }
end
