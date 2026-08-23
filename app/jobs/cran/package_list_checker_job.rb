require "open-uri"

class Cran::PackageListCheckerJob < ApplicationJob
  queue_as :default

  def perform
    URI.open("https://cran.r-project.org/src/contrib/PACKAGES").read.lines(chomp: true).select do |line|
      line.starts_with?("Package", "Version")
    end.each_slice(2) do |slice|
      name = slice.first.split(": ").last
      version = slice.last.split(": ").last

      unless PackageVersion.exists?(package_id: Package.find_by(name: name)&.id, version: version)
        Cran::PackageImporterJob.perform_later(name, version)
      end
    end
  end
end
