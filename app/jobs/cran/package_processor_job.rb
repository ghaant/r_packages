class Cran::PackageProcessorJob < ApplicationJob
  queue_as :default

  def perform(cran_package_id)
    return if cran_package_id.blank?

    cran_package = Cran::Package.find_by(id: cran_package_id)
    return if cran_package.blank?

    package = Package.find_or_initialize_by(name: cran_package.package)
    package.title = cran_package.title
    package.description = cran_package.description
    package.save!

    package_version =
      PackageVersion.create!(
        package: package,
        version: cran_package.version,
        cran_package: cran_package,
        published_at: cran_package.date_publication
      )

    cran_package.author.split(/(?<=[\]\)>])\s*,\s*/).map { |name| name.split(/[\(\[<]/).first&.strip }.
      reject { |name| name.include?(")") }.compact.each do |name|
      contributor = Contributor.find_or_create_by!(name: name)

      PackageVersionContributor.create!(
        package_version: package_version,
        contributor: contributor,
        is_author: true
      )
    end

    email_start = cran_package.maintainer.index("<") + 1
    email_end = cran_package.maintainer.index(">")
    maintainer_name = cran_package.maintainer[0..(email_start - 3)]
    maintainer_email = cran_package.maintainer[email_start...email_end]
    maintainer = Contributor.find_or_create_by!(name: maintainer_name)
    maintainer.update!(email: maintainer_email)

    package_version_contributor = PackageVersionContributor.find_or_initialize_by(
        package_version: package_version,
        contributor: maintainer,
    )

    package_version_contributor.is_maintainer = true
    package_version_contributor.save!
  end
end
