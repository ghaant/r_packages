class PackageVersionsController < ApplicationController
  def index
    @package_versions =
      PackageVersion.includes(:package, package_version_contributors: :contributor).order(packages: { name: :asc }, version: :desc)
  end
end
