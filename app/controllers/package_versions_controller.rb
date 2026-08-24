class PackageVersionsController < ApplicationController
  def index
    @package_versions = PackageVersion.includes(:package, :contributors)
  end
end
