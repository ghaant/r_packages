class PackageVersionsController < ApplicationController
  def index
    @package_versions = PackageVersion.includes(:package, :contributors).order(packages: { name: :asc }, version: :desc)
  end
end
