class Cran::Package < ApplicationRecord
  has_one :package_version
end
